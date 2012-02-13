#encoding: utf-8
require "pelusa/version"
require 'pp'
require 'set'

module Pelusa
  def self.run(argv)
    arguments = argv.dup

    puts "  OO Best Practices"
    puts "  ================="

    if arguments.empty?
      arguments = Dir["**/*.rb"]
    end

    arguments.each do |file|
      ast = Rubinius::Melbourne.parse_file(file)

      classes = []

      get_classes = lambda do |node|
        if node.is_a?(Rubinius::AST::Class)
          classes << node
        end
      end

      class_iterator = Script.iterator(&get_classes)

      Array(ast).each(&class_iterator) # Get classes

      next unless classes.any?

      puts "  \e[0;36m#{file}\e[0m"

      classes.each do |klass|
        puts
        puts "  class #{klass.name.name}"
        Script.new(klass).lint!
      end
      puts
    end
  end

  class Report
    def initialize(object=nil, &block)
      @object = object
      @block  = block
    end

    def empty?
      !@object && !@block
    end

    def inspect
      @block.call(@object)
    end
  end

  class Script < Struct.new(:ast)

    Iterator = lambda do |node, check|
      check.call(node)

      if node.respond_to?(:each)
        node.each { |node| Iterator.call(node, check) }
      else
        node.instance_variables.
          map { |ivar| node.instance_variable_get(ivar) }.
          each { |node| Iterator.call(node, check) }
      end
    end

    def self.iterator(&block)
      lambda { |node| Iterator.call(node, block) }
    end

    def lint!
      check_line_restriction!
      check_instance_variables!
      check_demeter_law!
      check_indentation_levels!
      check_else_clauses!
      check_getters_and_setters!
      check_collection_wrappers!
      check_short_identifiers!
    end

    def check_line_restriction!
      lines = []

      iterate = self.class.iterator do |node|
        if node.respond_to?(:line)
          lines << node.line
        end
      end

      report "Is below 50 lines" do
        Array(ast).each(&iterate)
        num = lines.max - lines.min
        if num < 50
          Report.new
        else
          Report.new(num) { |lines| "This class has #{num} lines." }
        end
      end
    end

    def check_instance_variables!
      ivars = Set.new

      iterate = self.class.iterator do |node|
        if node.is_a?(Rubinius::AST::InstanceVariableAccess) || node.is_a?(Rubinius::AST::InstanceVariableAssignment)
          ivars << node.name
        end
      end

      report "Uses less than 3 ivars" do
        Array(ast).each(&iterate)
        if ivars.length < 3
          Report.new
        else
          Report.new(ivars) { |ivars| "This class uses #{ivars.length} instance variables: #{ivars.to_a.join(', ')}."}
        end
      end
    end

    def check_demeter_law!
      violations = Set.new

      iterate = self.class.iterator do |node|
        if node.is_a?(Rubinius::AST::Send) && node.receiver.is_a?(Rubinius::AST::Send)
          violations << node.line
        end
      end

      report "Respects Demeter law" do
        Array(ast).each(&iterate)
        if violations.empty?
          Report.new
        else
          Report.new(violations) { |violations| "There are #{violations.length} Demeter law violations in lines #{violations.to_a.join(', ')}." }
        end
      end
    end

    def check_indentation_levels!
      violations = Set.new

      get_body_from_node = lambda do |node|
        if node.respond_to?(:body) && !node.body.is_a?(Rubinius::AST::NilLiteral)
           node.body
        elsif node.respond_to?(:else)
           node.else
        end
      end

      iterate = self.class.iterator do |node|
        if node.is_a?(Rubinius::AST::Define)
          _iterate = self.class.iterator do |node|
            __iterate = self.class.iterator do |node|
              if body = get_body_from_node[node]
                if node.line != [body].flatten.first.line
                  violations << body.line
                end
              end
            end

            Array(get_body_from_node[node]).each(&__iterate)
          end
          node.body.array.each(&_iterate)
        end
      end

      report "Doesn't use more than one indentation level" do
        Array(ast).each(&iterate)
        if violations.empty?
          Report.new
        else
          Report.new(violations) { |violations| "There's too much of indentation at lines #{violations.to_a.join(', ')}." }
        end
      end
    end

    def check_else_clauses!
      violations = Set.new

      iterate = self.class.iterator do |node|
        if node.is_a?(Rubinius::AST::If)
          has_body = node.body && !node.body.is_a?(Rubinius::AST::NilLiteral)
          has_else = node.else && !node.else.is_a?(Rubinius::AST::NilLiteral)

          if has_body && has_else
            violations << node.else.line
          end
        end
      end

      report "Doesn't use else clauses" do
        Array(ast).each(&iterate)
        if violations.empty?
          Report.new
        else
          Report.new(violations) { |violations| "There are #{violations.length} else clauses in lines #{violations.to_a.join(', ')}" }
        end
      end
    end

    def check_getters_and_setters!
      violations = Set.new

      iterate = self.class.iterator do |node|
        if node.is_a?(Rubinius::AST::Send)
          if [:attr_accessor, :attr_writer, :attr_reader].include? node.name
            violations << node.line
          end
        end
      end

      report "Doesn't use getters, setters or properties" do
        Array(ast).each(&iterate)
        if violations.empty?
          Report.new
        else
          Report.new(violations) { |violations| "There are getters, setters or properties in lines #{violations.to_a.join(', ')}" }
        end
      end
    end

    def check_collection_wrappers!
      violations = Set.new

      array_assignment = nil

      get_array_assignment = self.class.iterator do |node|
        if node.is_a?(Rubinius::AST::InstanceVariableAssignment) &&
          (node.value.is_a?(Rubinius::AST::ArrayLiteral) ||
          node.value.is_a?(Rubinius::AST::EmptyArray))
            array_assignment = node
        end
      end

      Array(ast).each(&get_array_assignment)

      iterate = self.class.iterator do |node|
        next if node == array_assignment || !array_assignment

        if node.is_a?(Rubinius::AST::InstanceVariableAssignment)
          violations << node.line
        elsif node.is_a?(Rubinius::AST::InstanceVariableAccess) && node.name != array_assignment.name
          violations << node.line
        end
      end

      report "Doesn't mix array instance variables with others" do
        Array(ast).each(&iterate)
        if violations.empty?
          Report.new
        else
          Report.new(violations) { |violations| "Using an instance variable apart from the array ivar in lines #{violations.to_a.join(', ')}" }
        end
      end
    end

    def check_short_identifiers!
      violations = []

      iterate = self.class.iterator do |node|
        if node.respond_to?(:name)
          name = node.name.respond_to?(:name) ? node.name.name.to_s : node.name.to_s
          if name =~ /[a-z]/ && name.length < 3 && !["p", "pp"].include?(name)
            next if name =~ /^[A-Z]/ # Ignore constants
            violations << [name, node.line]
          end
        end
      end

      report "Uses descriptive names" do
        Array(ast).each(&iterate)
        if violations.empty?
          Report.new
        else
          grouped_violations = violations.inject({}) do |hash, (name, line)|
            hash[name] ||= []
            hash[name] << line
            hash
          end

          formatted_violations = []

          grouped_violations.each_pair do |name, lines|
            formatted_violations << "#{name} (line #{lines.join(', ')})"
          end

          Report.new(violations) { |violations| "Names are too short: #{formatted_violations.join(', ')}" }
        end
      end
    end

    private

    def report(lint, &block)
      print "    \e[0;33m✿ %s \e[0m" % lint
      result = block.call
      if result.empty?
        print "\e[0;32m✓\e[0m\n"
      else
        print "\e[0;31m✗\n\t"
        pp result
        print "\e[0m"
      end
    end
  end
end
