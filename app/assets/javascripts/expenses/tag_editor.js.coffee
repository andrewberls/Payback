tagLimit    = 4
placeholder = 'Enter your own tags'
check_icon  = '<i class="icon-white icon-ok"></i>'

# Recommended tag selection
# ----------------------
$('.core-tag').click ->
  type        = $(@).data('type')
  wasSelected = $(@).hasClass('selected')
  $(@).toggleClass('btn-green').toggleClass('selected')

  if wasSelected
     # Unselecting - revert to plain btn + name
    $(@).html(type)
    enableInput() if numSelectedTags() < tagLimit
  else
    # Selecting - add check
    $(@).html(check_icon + type)

  disableInput() if numSelectedTags() >= tagLimit



# Tag editor
# ----------------------
$form     = $('.new-expense-form')
$tagInput = $("#tag_input")
keyEnter  = 13
keyBack   = 8
keyComma  = 188

# Bind keyup handlers when editor has focus
#   up/down - scroll through list of suggestions
#   enter - choose selected tag
#   backspace - erase most recent tag if present
#   comma - insert a tag for the last word
#   letter - wait a bit and query the server for suggestions
bindKeyHandlers = ->
  timeout = -1

  # Prevent enter key from prematurely submitting form,
  # and enforce 4-tag limit
  $form.on 'keydown', (e) ->
    if numSelectedTags() >= tagLimit || e.which == keyEnter
      return false

  $tagInput.on 'keyup', (e) ->
    keyCode = (e.which || e.keyCode)
    name    = $(@).val()

    switch keyCode
      when keyBack then eraseLastTag()
      when keyEnter
        addTag(name)
      when keyComma
        addTag name.slice(0, -1) # Slice off comma
        $(@).val('')

    if numSelectedTags() >= tagLimit
      disableInput()
      $(@).val('')


# Remove key handlers (unfocused from editor)
unbindKeyHandlers = ->
  $form.off('keydown')
  $tagInput.off('keyup')


# Grow or shrink input field to fit next to tags
resizeInput = ->
  numTags = totalWidth = 0
  for el in $('.tag')
    numTags++
    totalWidth += $(el).outerWidth()

  tagMargin   = 8
  editorWidth = $('.tag-editor').width()
  newWidth    = editorWidth - totalWidth - (tagMargin * numTags)
  $tagInput.css('width', newWidth)


# Un-disable the field and allow tags to be entered
enableInput = ->
  $tagInput.attr('placeholder', placeholder)
  $(".core-tag").removeClass('btn-disabled')


# Prevent any more tags from being entered
disableInput = ->
  $tagInput.attr('placeholder', '')
  $(".core-tag:not([class*='selected'])").addClass('btn-disabled')


# Number of core tags selected and tags entered
# Enforced to limit of 4
numSelectedTags = ->
  $('.tag').length + $('.core-tag.selected').length


# Insert a new tag into the editor
addTag = (name) ->
  if name != ''
    $('.tags').append """
      <span class='tag'>#{name}</span>
    """
    $tagInput.val('')
    resizeInput()


# Erases the last chosen tag (if present)
eraseLastTag = ->
  $last = $('.tag').last()
  if $last.length
    $last.remove()
    resizeInput()
    if numSelectedTags() < tagLimit
      enableInput()


# Populate a hidden field with the names of the tags we've chosen
# for parsing by the controller
normalizeTagList = ->
  extractValues = ($vals) ->
    $vals.map( (_, el) -> $(el).text() ).get()

  coreTags = extractValues $('.core-tag.selected')
  userTags = extractValues $('.tag')
  $('#tag_list').val coreTags.concat(userTags).join(',')

  true # Explicitly keep event going


$ ->
  $tagInput.on 'focus', bindKeyHandlers
  $tagInput.on 'blur',  unbindKeyHandlers

  $form.submit(normalizeTagList)
