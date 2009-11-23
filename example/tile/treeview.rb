require 'ffi-tk'
require 'find'

class FileTree < Tk::Tile::Treeview
  KB = 1024.0
  MB = KB * KB
  GB = MB * KB

  def populate_roots
    ## Create the tree and set it up
    configure columns: %w[fullpath type size], displaycolumns: %w[size]
    heading('#0', text: 'Directory Structure')
    heading('size', text: 'File Size')
    column('size', stretch: 0, width: 70)
    bind('<<TreeviewOpen>>'){|event|
      begin
        populate_tree(focus_item)
      rescue Exception => ex
        p ex
      end

      true
    }

    Tk.execute('file', 'volumes').sort.each do |volume|
      node = insert(nil, :end, text: volume, values: [volume, 'directory'])
      populate_tree(node)
    end
  end

  def populate_tree(node)
    return if node.set(:type) != 'directory'

    path = node.set(:fullpath)
    delete(*node.children.to_a)

    Dir.glob File.join(path, '*') do |path|
      name, type = File.basename(path), File.ftype(path)

      item = insert(node, :end, text: name, values: [path, type])

      if type == 'directory'
        ## Make it so that this node is openable
        dir_item = item.insert(0, text: 'dummy')
        dir_item.options(text: name)
      elsif type == 'file'
        size = File.size(path)

        if size >= GB
          size = '%.1f GB' % [size / GB]
        elsif size >= MB
          size = '%.1f MB' % [size / MB]
        elsif size >= KB
          size = '%.1f KB' % [size / KB]
        else
          size = '%.1f bytes' % [size]
        end

        item.set(:size, size)
      end
    end
  end
end

tree = FileTree.new
tree.bind('<Escape>'){ Tk.exit }
tree.pack expand: true, fill: :both
tree.focus
tree.populate_roots

Tk.mainloop
