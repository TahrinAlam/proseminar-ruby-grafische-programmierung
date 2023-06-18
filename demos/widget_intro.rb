# frozen_string_literal: true

require 'tk'

root = TkRoot.new do
  minsize 200, 150
  resizable false, false
  title 'Demo'
  bind 'Escape' do
    puts 'beende...'
    destroy
  end
end

TkLabel.new(root) do
  text 'Label'
  font 'monospace 15 bold'
  foreground 'indigo'
  pack
end

entry = TkEntry.new(root) do
  pack
end

spinner_variable = TkVariable.new(0)
TkSpinbox.new(root) do
  from 0
  to 100
  increment 1
  textvariable spinner_variable
  pack(pady: [10, 0])
end

checkbox_variable = TkVariable.new(0)
TkCheckButton.new(root) do
  text 'Entry Text'
  variable checkbox_variable
  pack
end

button = TkButton.new(root) do
  text 'Klick mich :)'
  command proc {
    if checkbox_variable.to_i == 1
      msg_text = entry.get
      title = 'Entry Text'
    else
      msg_text = spinner_variable.value
      title = 'Spinner Text'
    end
    Tk.messageBox(type: 'ok', message: "#{msg_text} :)", title: title)
  }
  pack(side: 'bottom', pady: [0, 10])
end

# TkButton.new(button) do
#   text 'Button Stack'
#   pack(padx: 10, pady: 10)
# end

Tk.mainloop
