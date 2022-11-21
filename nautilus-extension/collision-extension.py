"""
Add a Collision shortcut button to the right-click menu (Nautilus GTK4)

"""

from subprocess import Popen  # In order to open Collision on a new process. If not, Nautilus will freeze while the program is open
from urllib.parse import urlparse, unquote  # Necessary to parse file URI
from gi import require_version

require_version('Gtk', '4.0')
require_version('Nautilus', '4.0')

from gi.repository import Nautilus, GObject, Gtk, Gdk

class NautilusCollision(Nautilus.MenuProvider, GObject.GObject):

    def __init__(self):  # The constructor seems to be recquired, but I don't have anything to set up xD
        self.window = None
        return
    
    def openWithCollision(self, menu, files):  # Executed method when the right-click entry is clicked
        file_path = unquote(urlparse(files[0].get_uri()).path)
        Popen(["collision", file_path])  # Collision need to be in your PATH

    def get_file_items(self, files):
        if len(files) > 1:  # The option doesn't appear when there is more than 1 file selected (because Collision doesn't handle it yet)
            return ()

        menu_item = Nautilus.MenuItem(
                        name="collision",
                        label="Check Hashes")  # TODO : Add the ability to make this label translated with the .po files

        menu_item.connect('activate', self.openWithCollision, files)

        return menu_item,