function checker(jobID){
  $.get('/status/'+ jobID, function(status_response){
          console.log(status_response);
          if (status_response === 'false'){
            $('.messages').html('');
            $('.messages').append('<p> Working...</p>');
            setTimeout(checker(jobID), 250);
          } else{
            $('.messages').html('');
            $('.messages').append('<p> Tweet complete...</p>');
          };
  });
}


$(document).ready(function() {
  $('#tweet-layout').on('submit', function(e){
    e.preventDefault();
    var data = $(this).serialize();
    var url = $(this).attr('action');
    $(this)[0].reset();
    $.post(url, data, function(response){
      var jobID = response.jobID;
      checker(jobID);

    });
  });

  $('#tweet-layout-later').on('submit', function(e){
    e.preventDefault();
    var data = $(this).serialize();
    var url = $(this).attr('action');
    $(this)[0].reset();
    $.post(url, data, function(response){
      var jobID = response.jobID;
      checker(jobID);

    });
  });
});
// Send job id to status checker route
// If false, show waiting, recheck every .25 seconds
// If true show tweet sent!!!
