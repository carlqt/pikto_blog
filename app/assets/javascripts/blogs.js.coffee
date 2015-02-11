# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#all_blogs").on "click", ->
    check_value = this.checked
    blogs = $("[name='blog[]']:checkbox")
    blogs.each ->
      $(this).prop("checked", check_value)

  $("#blog-options").on "change", ->
    if this.value != ""
      blogs = $("[name='blog[]']:checkbox:checked")
      blogs_arr = []
      blogs.each (index)->
        blogs_arr.push this.value

      $.ajax
        type: "DELETE"
        url: "blogs/destroy_multiple"
        dataType: 'script'
        format: 'js'
        data: {ids:blogs_arr}
