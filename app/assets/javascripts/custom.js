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

    thisTask.find('.hours').html(formatCountTime(taskHour));
    thisTask.find('.minutes').html(formatCountTime(taskMinute));
    thisTask.find('.seconds').html(formatCountTime(taskSecond));
    thisTask.attr('data-hours', formatCountTime(taskHour));
    thisTask.attr('data-minutes', formatCountTime(taskMinute));
    thisTask.attr('data-seconds', formatCountTime(taskSecond));
}

function formatCountTime(thisNumber){
    if(thisNumber < 10){
        return `0${thisNumber}`
    }else{
        return thisNumber
    }
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
    let commandBox = $(".command-box");
    let commandInput = $("#command-input");
    if(commandBox.length > 0){
        if(e.keyCode === 73){
            if(commandBox.hasClass('d-none') === true){
                e.preventDefault();
                commandBox.removeClass('d-none');
            }
            if(commandInput.is(':focus') === false){
                e.preventDefault();
                commandInput.focus();
            }
        }else if(e.keyCode === 27){
            if(commandBox.hasClass('d-none') === false){
                commandBox.addClass('d-none');
            }
        }else if((e.keyCode === 38 || e.keyCode === 40) && commandBox.hasClass('d-none') === false){
            let history = JSON.parse(localStorage.getItem("commandHistory"));
            let cursor = history.length - 1;
            let newValue;
            let newCursor;
            if(window.currentCursor !== undefined && window.currentCursor !== ''){
                cursor = window.currentCursor;
            }
            if(e.keyCode === 38){
                newCursor = cursor - 1;
                newValue = history[newCursor];
            }else if(e.keyCode === 40){
                newCursor = cursor + 1;
                newValue = history[newCursor];
            }
            if(newValue !== undefined && newValue !== ''){
                commandInput.val(newValue);
                setTimeout(function () {
                    commandInput.setCursorToTextEnd();
                }, 1);
                window.currentCursor = newCursor;
            }
        }
    }
});

$(document).on('submit', '#command-form', function () {
    let newHistory = [];
    let inputValue = $("#command-input").val();
    let localHistory = localStorage.getItem("commandHistory");
    if(localHistory !== undefined && localHistory !== '' && localHistory !== null){
        newHistory = JSON.parse(localHistory);
        newHistory.push(inputValue);
    }else{
        newHistory.push(inputValue)
    }
    window.currentCursor = newHistory.length;
    localStorage.setItem("commandHistory", JSON.stringify(newHistory));
    $('.command-box').addClass('d-none');
});

(function($){
    $.fn.setCursorToTextEnd = function() {
        this.focus();
        var $thisVal = this.val();
        this.val('').val($thisVal);
        return this;
    };
})(jQuery);