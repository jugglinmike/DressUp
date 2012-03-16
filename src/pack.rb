#!/usr/bin/env ruby
# Prepare CSS for inclusion in a JavaScript string: escape quotes and remove
# newlines
def prep_css( css, quote_str )
  css = css.gsub(/#{quote_str}/, "\\\\" + quote_str)
  quote_str + css.gsub(/\r|\n/, " ") + quote_str
end

def parse_rules( contents, all_rules )
  contents.scan(/([^{]+){([^}]+)}/) { |selectors, declarations|
    all_rules[ selectors.strip ] = declarations.strip
  }
end

def process_js( contents, directory, all_rules )

  # Import rules
  contents.gsub!(/(["'])\s*!import_rule\s+(.+)\1/) { |matched|

    quote_str = $1
    selectors = $2
    rule = all_rules[selectors]

    # Ignore unrecognized rules
    if( !rule )
      next matched
    end
    
    prep_css(rule, quote_str)
  }

  # Import files
  contents.gsub(/(["'])\s*!import_file\s+(.+)\s*\1/) { |matched|

    quote_str = $1
    file_name = directory + File::SEPARATOR + $2

    # Exit with an error if an unreadable file was specified
    if !File.file?(file_name) || !File.readable?(file_name)
      exit 1;
    end

    css = File.open(file_name, "rb") { |f| f.read }

    prep_css(css, quote_str)
  }
end

file_names = {
  js: [],
  css: []
}
# A hash of all CSS rules parsed from the files specified as arguments to this
# script, indexed by selector string
all_rules = {}

ARGV.each do |file_name|

  next if !File.file?(file_name) || !File.readable?(file_name)

  file_name =~ /\.(css|js)/i
  file_type = $1.to_sym

  file_names[ file_type ].push(file_name);

end

# Parse all input CSS files for rules (this is done first so that command-line
# argument order does not matter)
file_names[:css].each do |file_name|

  contents = File.open(file_name, "rb") { |f| f.read }
  parse_rules(contents, all_rules)

end

# Parse all JS files for rule- and file-import statements
file_names[:js].each do |file_name|

  # Get the directory of the JavaScript file, so CSS include paths within that
  # file can be resolved relative to the file (and not the currently-executing
  # script)
  directory = File.absolute_path(File.dirname(file_name))

  contents = File.open(file_name, "rb") { |f| f.read }

  print process_js(contents, directory, all_rules)

end
