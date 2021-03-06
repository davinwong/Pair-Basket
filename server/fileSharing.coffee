Knox = Meteor.require("knox")

knox = null
S3 = null

Meteor.methods
  S3config: (object) ->
    knox = Knox.createClient(object)
    S3 = 
      directory: object.directory || "/"

  # Uploads file
  S3upload: (file) ->
    console.log "Uploading file to S3"

    # Set file unique id
    extension = (file.name).match(/\.[0-9a-z]{1,5}$/i) || ""
    _filename = file.name
    file.name = Meteor.uuid() + extension
    path = S3.directory + file.name

    buffer = new Buffer(file.data)

    # Run putBuffer using sync utility. Fn waits until result is available.
    # Then it calls done with url set to knox.http(path)
    # url = {result: ..., error: ...}
    url = Async.runSync (done) ->
      knox.putBuffer buffer, path, {"Content-Type":file.type,"Content-Length":buffer.length}, (error, result) ->
        if result
          done(null, knox.http(path))
        else
          console.log error

    _file = 
      url: url.result
      path: file.name
      name: _filename
      dateCreated: new Date

    if url.error
      return false
    else
      return _file

  # Deletes file on S3 server
  S3delete: (path) ->
    result = Async.runSync (done) ->    
      knox.deleteFile path, (error, result) ->
        if error
          console.log "Error deleting S3 file"
          console.log error
        else
          console.log result

        done(null, if result then true else false)

    console.log result

    return result.result