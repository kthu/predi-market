
formatDate = (date) ->
  moment.locale TAPi18n.getLanguage()
  value = moment(date).format('MMMM Do YYYY, h:mm a');
  value


Template.ListHints.helpers
  hints: ->
    value = Contracts.find({hints: {$exists: true}}).fetch()
    hintUpdatedArr = [];
    i = 0
    while i < value.length
      Session.set 'date', value[i].set_id
      set_id = value[i].set_id
      contract_title = Contractsets.findOne({_id: set_id})
      if contract_title
        name = contract_title.title
      hintArr = value[i].hints
      j = 0
      length = hintArr.length
      if length
        while j < length
          if hintArr[j].isAdmin == false
            hintArr[j]['title'] = name
            hintUpdatedArr.push(hintArr[j])
          j++
      i++
    hintUpdatedArr = _.sortBy hintUpdatedArr, 'createdAt'
    return hintUpdatedArr.reverse()

  formattedDate: formatDate

  buttonCheck:(approved) ->
    if approved == false
      return true

Template.ListHints.events
  'click .approve_hint': (evt, tmpl) ->
    evt.stopPropagation()
    id = evt.currentTarget.id
    value = evt.currentTarget.value
    Meteor.call 'approveHint', value, (error, result) ->
      if error
        $(".error").show()
        Meteor.setTimeout (->
          $(".error").hide()
        ), 3000
      else
        $(".success").show()
        Meteor.setTimeout (->
          $(".success").hide()
        ), 3000
      true

  'click .delete_hint': (evt,tmpl) ->
    evt.stopPropagation()
    id= evt.currentTarget.id
    value = evt.currentTarget.value
    Meteor.call 'removeUserHint', id, value, (error, result) ->
      if error
        $(".error").show()
        Meteor.setTimeout (->
          $(".error").hide()
        ), 3000
      else
        $(".delete").show()
        Meteor.setTimeout (->
          $(".delete").hide()
        ), 3000
      true

  'click .edit_hint': (evt, tmpl) ->
    evt.stopPropagation()
    id = evt.currentTarget.id
    value = evt.currentTarget.value
    Session.set 'hint_value', value
    Session.set 'admin_section', 'editHint'
