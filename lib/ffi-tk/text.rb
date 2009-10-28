module Tk
  class Text < Widget
    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('text', assign_pathname, options)
    end

    # pathName insert index chars ?tagList chars tagList ...?
    #
    # Inserts all of the chars arguments just before the character at index.
    #
    # If index refers to the end of the text (the character after the last
    # newline) then the new text is inserted just before the last newline
    # instead.
    # If there is a single chars argument and no tagList, then the new text will
    # receive any tags that are present on both the character before and the
    # character after the insertion point; if a tag is present on only one of
    # these characters then it will not be applied to the new text.
    # If tagList is specified then it consists of a list of tag names; the new
    # characters will receive all of the tags in this list and no others,
    # regardless of the tags present around the insertion point.
    # If multiple chars-tagList argument pairs are present, they produce the
    # same effect as if a separate pathName insert widget command had been
    # issued for each pair, in order.
    # The last tagList argument may be omitted.
    def insert(index, string, taglist = nil, *rest)
      execute('insert', index, *[string, taglist, *rest].compact)
    end

    def bbox(index)
      execute_with_result('bbox', index).to_array(:to_i)
    end

    def cget(option)
      option = option.to_s
      option[0,0] = '-' unless option[0] == '-'
      result = execute_with_result('cget', option)

      case option
      when '-height', '-width', '-maxundo', '-spacing1', '-spacing2', '-spacing3', '-borderwidth', '-bd', '-highlightthickness', '-insertborderwidth', '-insertofftime', '-insertontime', '-insertwidth', '-padx', '-pady', '-selectborderwidth'
        result.to_i
      when '-wrap', '-state', '-tabstyle', '-relief', '-xscrollcommand', '-yscrollcommand'
        result.to_sym
      when '-autoseparators', '-blockcursor', '-undo', '-exportselection', '-setgrid', '-takefocus'
        result.to_boolean
      when '-endline', '-startline'
        result.empty? ? nil : result.to_i
      when '-inactiveselectbackground', '-background', '-bg', '-foreground', '-fg', '-highlightbackground', '-highlightcolor', '-insertbackground', '-selectbackground', '-selectforeground'
        result.to_color
      when '-tabs', '-cursor'
        result
      when '-font'
        result.to_font
      else
        raise "Unknown option: %p" % [option]
      end
    end

    def index(index)
      execute_with_result('index', index).to_index
    end
  end
end