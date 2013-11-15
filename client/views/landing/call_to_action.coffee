sendQuestion = ->
  email = $('input[type=email]').val()
  password = $('input[type=password]').val()
  question = $('textarea.question').val()

  console.log email, password, question

  # Clean input

  # Validate email

  # Validate password

  # Create meteor account

  # Log the user in

  Session.set('questionFromLandingPrompt', question)
  Session.set('askingQuestion?', true)

  # Router.go('dashboard')

Template.landingCallToAction.helpers
  helpOthers: ->
    Session.get('helpOthers?')

  askQuestion: ->
    Session.get('askQuestion?')

  showBoth: ->
    console.log 'showBoth?', Session.get('showBoth?')
    Session.get('showBoth?')

  # showHelpOthersAndAskQuestion: ->
  #   not (Session.get('helpOthers?') and Session.get('askQuestion?'))

logSession = ->
  ['askQuestion?', 'helpOthers?', 'showBoth?'].forEach (vars) ->
    console.log vars, Session.get(vars)

Template.landingCallToAction.events =
  'click .ask-question-btn': (e, s) ->
    Session.set('askQuestion?', true)

    Session.set('helpOthers?', false)
    Session.set('showBoth?', false)

    logSession()

  'click .help-others-btn': (e, s) ->
    Session.set('helpOthers?', true)

    Session.set('askQuestion?', false)
    Session.set('showBoth?', false)

    logSession()

Template.landingHelpOthers.events =
  'submit': (e, s) ->
    # sendQuestion()

Template.landingAskQuestion.events =
  'submit': (e, s) ->
    e.preventDefault()
    console.log 'submit'

    # Clean input
    email = $('input[type=email]').val().trim()
    password = $('input[type=password]').val().trim()
    question = $('textarea.question').val().trim()

    # Validate inputs - for now just check if all inputs were entered
    isInputValid = [email, password, question].every (input) -> input.length

    if isInputValid

      # Create meteor account, on client will log-in upon successful completion
      Accounts.createUser {email: email, password: password}, (err) ->
        if err
          console.log err
          # throw new Meteor.Error(401, err)
        else
          # Success, account was created
          Session.set('questionFromLandingPrompt', question)
          Session.set('askingQuestion?', true)
          Router.go('dashboard')
    else
      # Throw some message
      console.log "invalid input"