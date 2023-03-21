let isHorizontal = false;
let urls = [];
let initialLaunch = true;

// vertical -> 1000px x 1000px
// horizontal -> 1200px x 1200px

window.addEventListener('message', (event) => {
    if (event.data.action == 'open') {
        isHorizontal = event.data.horizontal;
        urls = event.data.data;

        const el = document.getElementById('tablet');
        el.style.display = 'block';
        
        if (initialLaunch) {
            setContent()
            initialLaunch = false;
        }
    }
});

function setContent() {
    const el = document.getElementById('content');
    for (let i = 0; i < urls.length; i++) {
        // Create a new element which will be our new child.
        const newEl = document.createElement('div');
        // Append some classes to the new element.
        newEl.classList.add(
            "mr-4", "mb-4", "p-4", "bg-gray-500", "rounded-lg",
            "hover:bg-gray-700", "cursor-pointer", "transition-all",
            "content-item"
        );
        newEl.setAttribute('data-url', urls[i].url);
        newEl.addEventListener('click', openPage);
        const icon = document.createElement('i');
        icon.setAttribute('data-url', urls[i].url);
        const icons = urls[i].icon.split(' ');
        for (let i = 0; i < icons.length; i++) {
            icon.classList.add(icons[i]);
        }
        newEl.append(icon);
        el.append(newEl);
    }
}

function openPage(event) {
    if (!event.target.getAttribute('data-url')) {
        return;
    }

    const url = event.target.getAttribute('data-url');

    document.getElementById('app-wrapper').style.display = 'block';
    document.getElementById('homescreen').style.display = 'none';
    document.getElementById('app-content').setAttribute('src', url);
}

document.addEventListener('click', (event) => {
    if (event.target.getAttribute('id') == 'closeApp') {
        document.getElementById('homescreen').style.display = 'block'; 
        document.getElementById('app-wrapper').style.display = 'none';
        document.getElementById('app-content').setAttribute('src', null);
    }
});

document.onkeydown = function (e) {
    if (e.key == 'Escape') {
        const el = document.getElementById('tablet');
        el.style.display = 'none';
        axios.post('https://blazefire-tab/close');
    }
}