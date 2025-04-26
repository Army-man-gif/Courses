import kivy
from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.textinput import TextInput
from kivy.uix.label import Label
class SpartanGrid(GridLayout):

    def __init__(self,**kwargs):
        super(SpartanGrid, self).__init__()

        self.add_widget(Label(text="Student Name: "))

if __name__ == "__main__":
    SpartanApp().run()