# frozen_string_literal: true
module Tk
  module Image
    module_function

    # Creates an image and a commend of the same name.
    # Returns the name of the command containing the image.
    #
    # +type+ specifies the type of the image, which must be one of the types
    # currently defined (e.g., bitmap or photo).
    #
    # +name+ specifies the name for the image; if it is ommitted then Tk picks a
    # name of the form imagex, where x is an integer.
    #
    # +options+ may be a Hash containing configuration options for the new
    # image.
    #
    # The legal set of +options+ is defined separately for each image type; see
    # documentation of [Image] for built-in image types.
    #
    # If a proc already exists with the given name, then it is replaced with
    # the new image and any instances of that image will redisplay with the new
    # contents.
    # It is important to note that [create] will silently overwrite any existing
    # images of the same name, so choose the name wisely.
    #
    # It is recommended to use a separate namespace for image names, like
    # "::img::logo" or "::img::large"
    def create(type, name = None, options = None)
      if None == name
        Tk.execute(:image, :create, type)
      elsif None == options && name.respond_to?(:to_hash)
        Tk.execute(:image, :create, type, name.to_tcl_options)
      elsif None != name && None != options
        Tk.exeucte(:image, :create, type, name, options.to_tcl_options)
      end
    end

    # Deletes each of the named images and returns an empty string.
    # If there are instances of the images displayed in widgets, the images
    # will not actually be deleted until all of the instances are released.
    # However, the association between the instances and the image manager will
    # be dropped.
    # Existing instances will retain their sizes but redisplay as empty areas.
    # If a deleted image is recreated with another call to image create, the
    # existing instances will use the new image.
    def delete(*names)
      Tk.execute(:image, :delete, *names)
    end

    # Returns a decimal string giving the height of image name in pixels.
    def height(name)
      Tk.execute(:image, :height, name)
    end

    # Returns a boolean value indicating whether or not the image given by name
    # is in use by any widgets.
    def inuse(name)
      Tk.execute(:image, :inuse, name).to_boolean
    end

    # Returns a list containing the names of all existing images.
    def names
      Tk.execute(:image, :names).to_a
    end

    # Returns the type of image name (the value of the type argument to image
    # create when the image was created).
    def type(name)
      Tk.execute(:image, :type, name).to_sym
    end

    # Returns a list whose elements are all of the valid image types (i.e., all
    # of the values that may be supplied for the type argument to image
    # create).
    def types
      Tk.execute(:image, :types).to_a(&:to_sym)
    end
  end
end
