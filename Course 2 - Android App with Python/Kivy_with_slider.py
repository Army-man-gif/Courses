import kivy
from kivy.app import App
from kivy.uix.slider import Slider
from kivy.uix.label import Label
from kivy.uix.boxlayout import BoxLayout

class SpartanApp(App):

    def build(self):
        self.layout = BoxLayout(orientation='vertical')
        self.slider = Slider(min=0, max=100, value=50)
        self.label = Label(text=str(self.slider.value))

        def on_slider_value_change(instance, value):
            self.label.text = str(value)
        
        self.slider.bind(value=on_slider_value_change)
        
        self.layout.add_widget(self.slider)
        self.layout.add_widget(self.label)
        return self.layout
  

if __name__ == "__main__":
    SpartanApp().run()