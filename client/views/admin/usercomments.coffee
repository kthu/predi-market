
formatDate = (date) ->
  moment.locale TAPi18n.getLanguage()
  value = moment(date).format('MMMM Do YYYY, h:mm a');
  value

findHint = (hint_id) ->
  hint = Contracts.findOne({"hints.id": hint_id}, {fields: {hints: 1}})
  hintVal = hint.hints
  val = hintVal.filter (d) ->
    return d.id == hint_id
  return val[0].hint

Template.ListComment.helpers
  comments: ->
    comments = Comments.find({}).fetch()
    return comments

  url:(comment) ->
    re = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    commentUrl = comment.replace(re, "<a id='urlClass' href='$1'>$1</a>")
    return commentUrl

  formattedDate: formatDate

  hint: findHint

Template.ListComment.events
  "click .url": (evt, tmpl) ->
    evt.preventDefault()
    value = evt.currentTarget.href
    window.open(value + location.search)

  'click .delete_comment': (evt, tmpl) ->
    id = evt.currentTarget.id
    Meteor.call 'deleteUserComment', id, (error, result) ->
      if error
        console.log(error)
      true
