# -*- coding: utf-8 -*-
#
#--
# Copyright (C) 2009 Thomas Leitner <t_leitner@gmx.at>
#
# This file is part of kramdown.
#
# kramdown is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++
#

module Kramdown

  # This module defines all options that are used by parsers and/or converters.
  module Options

    # Helper class introducing a boolean type for specifying boolean values (+true+ and +false+) as
    # option types.
    class Boolean

      # Return +true+ if +other+ is either +true+ or +false+
      def self.===(other)
        FalseClass === other || TrueClass === other
      end

    end

    # ----------------------------
    # :section: Option definitions
    #
    # This sections informs about the methods that can be used on the Options class.
    # ----------------------------

    # Contains the definition of an option.
    Definition = Struct.new(:name, :type, :default, :desc)

    # Allowed option types
    ALLOWED_TYPES = [String, Integer, Float, Symbol, Boolean, Array, Object]

    @options = {}

    # Define a new option called +name+ (a Symbol) with the given +type+ (String, Integer, Float,
    # Symbol, Boolean, Array, Object), default value +default+ and the description +desc+.
    #
    # The type 'Object' should only be used if none of the other types suffices because such an
    # option will be opaque!
    def self.define(name, type, default, desc)
      raise ArgumentError, "Option name #{name} is already used" if @options.has_key?(name)
      raise ArgumentError, "Invalid option type #{type} specified" if !ALLOWED_TYPES.include?(type)
      raise ArgumentError, "Invalid type for default value" if !(type === default) && !default.nil?
      @options[name] = Definition.new(name, type, default, desc)
    end

    # Return all option definitions.
    def self.definitions
      @options
    end

    # Return +true+ if an option +name+ is defined.
    def self.defined?(name)
      @options.has_key?(name)
    end

    # Return a Hash with the default values for all options.
    def self.defaults
      temp = {}
      @options.each {|n, o| temp[o.name] = o.default}
      temp
    end

    # Merge the #defaults Hash with the parsed options from the given Hash.
    def self.merge(hash)
      temp = defaults
      hash.each do |k,v|
        next unless @options.has_key?(k)
        temp[k] = parse(k, v)
      end
      temp
    end

    # Parse the given value +data+ as if it was a value for the option +name+ and return the parsed
    # value with the correct type.
    #
    # If +data+ already has the correct type, it is just returned. Otherwise it is converted to a
    # String and then to the correct type.
    def self.parse(name, data)
      raise ArgumentError, "No option named #{name} defined" if !@options.has_key?(name)
      return data if @options[name].type === data
      data = data.to_s
      if @options[name].type == String
        data
      elsif @options[name].type == Integer
        Integer(data)
      elsif @options[name].type == Float
        Float(data)
      elsif @options[name].type == Symbol
        (data.strip.empty? ? nil : data.to_sym)
      elsif @options[name].type == Boolean
        data.downcase.strip != 'false' && !data.empty?
      elsif @options[name].type == Array
        data.split(/\s+/)
      end
    end

    # ----------------------------
    # :section: Option Definitions
    #
    # This sections contains all option definitions that are used by the included
    # parsers/converters.
    # ----------------------------

    define(:template, String, '', <<EOF)
The name of an ERB template file that should be used to wrap the output

This is used to wrap the output in an environment so that the output can
be used as a stand-alone document. For example, an HTML template would
provide the needed header and body tags so that the whole output is a
valid HTML file. If no template is specified, the output will be just
the converted text.

When resolving the template file, the given template name is used first.
If such a file is not found, the converter extension is appended. If the
file still cannot be found, the templates name is interpreted as a
template name that is provided by kramdown (without the converter
extension).

kramdown provides a default template named 'default' for each converter.

Default: ''
Used by: all converters
EOF

    define(:auto_ids, Boolean, true, <<EOF)
Use automatic header ID generation

If this option is `true`, ID values for all headers are automatically
generated if no ID is explicitly specified.

Default: true
Used by: kramdown parser
EOF

    define(:parse_block_html, Boolean, false, <<EOF)
Process kramdown syntax in block HTML tags

If this option is `true`, the kramdown parser processes the content of
block HTML tags as text containing block level elements. Since this is
not wanted normally, the default is `false`. It is normally better to
selectively enable kramdown processing via the markdown attribute.

Default: false
Used by: kramdown parser
EOF

    define(:parse_span_html, Boolean, true, <<EOF)
Process kramdown syntax in span HTML tags

If this option is `true`, the kramdown parser processes the content of
span HTML tags as text containing span level elements.

Default: true
Used by: kramdown parser
EOF

    define(:extension, Object, nil, <<EOF)
An object for handling the extensions

The value for this option needs to be an object that can handle the
extensions found in a kramdown document. If this option is `nil`, the
default extension object is used.

Default: nil
Used by: kramdown parser
EOF

    define(:footnote_nr, Integer, 1, <<EOF)
The number of the first footnote

This option can be used to specify the number that is used for the first
footnote.

Default: 1
Used by: HTML converter
EOF

    define(:filter_html, Array, [], <<EOF)
An array of HTML tags that should be filtered from the output

The value can either be specified as array or as a space separated
string (which will be converted to an array). All HTML tags that are
listed in the array will be filtered from the output, i.e. only their
contents is used. This applies only to HTML tags found in the initial
document.

Default: []
Used by: HTML converter
EOF

    define(:coderay_wrap, Symbol, :div, <<EOF)
Defines how the highlighted code should be wrapped

The possible values are :span, :div or nil.

Default: :div
Used by: HTML converter
EOF

    define(:coderay_line_numbers, Symbol, :inline, <<EOF)
Defines how and if line numbers should be shown

The possible values are :table, :inline, :list or nil. If this option is
nil, no line numbers are shown.

Default: :inline
Used by: HTML converter
EOF

    define(:coderay_line_number_start, Integer, 1, <<EOF)
The start value for the line numbers

Default: 1
Used by: HTML converter
EOF

    define(:coderay_tab_width, Integer, 8, <<EOF)
The tab width used in highlighted code

Used by: HTML converter
EOF

    define(:coderay_bold_every, Integer, 10, <<EOF)
Defines how often a line number should be made bold

Default: 10
Used by: HTML converter
EOF

    define(:coderay_css, Symbol, :style, <<EOF)
Defines how the highlighted code gets styled

Possible values are :class (CSS classes are applied to the code
elements, one must supply the needed CSS file) or :style (default CSS
styles are directly applied to the code elements).

Default: style
Used by: HTML converter
EOF

  end

end
