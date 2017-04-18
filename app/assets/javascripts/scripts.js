function get_tasks() {
    $.get('http://localhost:5000/api/v1/tasks', function(data) {
        $(data).each(function() {
            $('table tbody').append('<tr class="task" id="task_' + this.id + '"><td>' + this.short_filename + '</td><td>' + this.from + '</td><td>' + this.to + '</td><td class="' + this.status + '">' + this.status + '</td><td><a download="' + this.result_short_filename + '" href="/uploads/task/result_file/' + this.id + '/' + this.result_short_filename + '">Download</a></td></tr>');
        });
    });
}

$(function() {
    get_tasks();
});