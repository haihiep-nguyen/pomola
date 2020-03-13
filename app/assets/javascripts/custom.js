$(document).ready(function () {
    $(document).on('submit', '#command-form', function () {
        $('#command-form input').val('');
    })
});

function updateTime(thisElem){
    let thisTask = thisElem;
    let taskHour = parseInt(thisTask.attr("data-hours"));
    let taskMinute = parseInt(thisTask.attr("data-minutes"));
    let taskSecond = parseInt(thisTask.attr("data-seconds"));

    if(taskSecond === '' || taskSecond === undefined){
        taskSecond = 0;
        taskMinute = 0;
        taskHour = 0;
    }else if(taskSecond !== '' && taskSecond !== undefined){
        if(taskSecond < 59){
            taskSecond += 1;
        }else if(taskSecond === 59){
            taskSecond = 0;
            taskMinute += 1;
        }
    }
    if(taskMinute === 60){
        taskHour += 1;
        taskMinute = 0;
    }

    thisTask.find('.hours').html(taskHour);
    thisTask.find('.minutes').html(taskMinute);
    thisTask.find('.seconds').html(taskSecond);
    thisTask.attr('data-hours', taskHour);
    thisTask.attr('data-minutes', taskMinute);
    thisTask.attr('data-seconds', taskSecond);
}

window.taskInterval = [];
function runStartingTask(elem){
    if(elem !== undefined && elem !== ''){
        let taskSerial = elem.attr('data-task-serial');
        window.taskInterval['t' + taskSerial] = setInterval(function () {
            updateTime(elem);
        }, 1000);
    }
}
$(document).ready(function () {
    $('.task-time-counter.running').each(function () {
        let thisElem = $(this);
        runStartingTask(thisElem);
    });
});

$(document).on('keydown', function(e){
    if(e.keyCode === 73 && $("#command-input").is(':focus') === false){
        e.preventDefault();
        $("#command-input").focus();
    }
});