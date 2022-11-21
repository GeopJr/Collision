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
    
    def get_background_items(self, files):  # Add a unclickable entry if the background is right-clicked (fixes the 'object not initialized' bug)
        menu_item = Nautilus.MenuItem(
                        name="NautilusCollision::NoFileSelected",
                        label="Hash not available",
                        sensitive=False)

        return menu_item,

    def get_file_items(self, files):
        if len(files) > 1 or (len(files) == 1 and files[0].is_directory()):  # The option doesn't appear when there is more than 1 file selected (because Collision doesn't handle it yet) or when a folder is selected
            return ()

        menu_item = Nautilus.MenuItem(
                        name="NautilusCollision::CheckHashes",
                        label="Check Hashes")  # TODO : Add the ability to make this label translated with the .po files

        menu_item.connect('activate', self.openWithCollision, files)

        return menu_item,