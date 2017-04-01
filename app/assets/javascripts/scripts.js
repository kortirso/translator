function get_tasks() {
    //$('table tbody tr').each(function() {
        //$(this).remove();
    //});

    $.get('http://localhost:3000/api/v1/tasks', function(data) {
        $(data).each(function() {
            $('table tbody').append('<tr class="task" id="task_' + this.id + '"><td>' + this.short_filename + '</td><td>' + this.from + '</td><td>' + this.to + '</td><td class="' + this.status + '">' + this.status + '</td><td><a download="' + this.result_short_filename + '" href="/uploads/task/result_file/' + this.id + '/' + this.result_short_filename + '">Download</a></td></tr>');
        });
    });

    //if(all_tasks != done_tasks) {
        //sleep(5000);
        //get_tasks();
    //}
}

//function sleep(milliseconds) {
//    var start = new Date().getTime();
//    for (var i = 0; i < 1e7; i++) {
//        if ((new Date().getTime() - start) > milliseconds){
//            break;
//        }
//    }
//}

$(function() {
    get_tasks();
});