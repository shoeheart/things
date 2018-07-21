# frozen_string_literal: true

module ApplicationHelper
  def component(component_name, locals = {}, &block)
    name = component_name.split("_").first
    render("components/#{name}/#{component_name}", locals, &block)
  end

  alias c component

  def rc(component_path, arguments)
    react_component(component_path, arguments)
  end
end
