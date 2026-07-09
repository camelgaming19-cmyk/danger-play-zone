let currentTipIndex = 0;
let currentResourceIndex = 0;
let loadingData = {};

// Show loading screen
window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'showLoading') {
        loadingData = data;
        showLoadingScreen(data);
    } else if (data.action === 'updateProgress') {
        updateProgress(data.progress);
    } else if (data.action === 'hideLoading') {
        hideLoadingScreen();
    }
});

function showLoadingScreen(data) {
    const container = document.getElementById('loading-container');
    container.classList.remove('hidden');

    // Set server info
    document.getElementById('server-name').textContent = data.serverName || 'Server';
    document.getElementById('server-motd').textContent = data.serverMotd || 'Welcome!';

    // Set background
    if (data.colors) {
        const primary = data.colors.primary;
        const secondary = data.colors.secondary;
        const overlay = document.getElementById('gradient-overlay');
        overlay.style.background = `linear-gradient(135deg, rgba(${primary[0]}, ${primary[1]}, ${primary[2]}, 0.4) 0%, rgba(${secondary[0]}, ${secondary[1]}, ${secondary[2]}, 0.4) 100%)`;
    }

    // Set up tips
    if (data.showTips && data.tips && data.tips.length > 0) {
        displayRandomTip(data.tips);
        setInterval(() => displayRandomTip(data.tips), 5000);
    }

    // Set up resources list
    if (data.resources && data.resources.length > 0) {
        populateResources(data.resources);
    }

    // Show/hide skip button
    const skipBtn = document.getElementById('skip-btn');
    if (data.enableSkip) {
        skipBtn.classList.remove('hidden');
        skipBtn.addEventListener('click', skipLoading);
        document.addEventListener('keydown', handleKeyPress);
    } else {
        skipBtn.classList.add('hidden');
    }
}

function hideLoadingScreen() {
    const container = document.getElementById('loading-container');
    container.classList.add('hidden');
    document.removeEventListener('keydown', handleKeyPress);
}

function updateProgress(progress) {
    const bar = document.getElementById('loading-bar');
    const text = document.getElementById('progress-text');
    
    bar.style.width = progress + '%';
    text.textContent = Math.round(progress) + '%';

    // Simulate resource loading
    if (loadingData.resources && loadingData.resources.length > 0) {
        const resourcesLoaded = Math.floor((progress / 100) * loadingData.resources.length);
        updateResourcesList(resourcesLoaded);
    }
}

function displayRandomTip(tips) {
    if (!tips || tips.length === 0) return;
    
    currentTipIndex = Math.floor(Math.random() * tips.length);
    const tip = tips[currentTipIndex];
    const tipText = document.getElementById('tips-text');
    
    tipText.style.animation = 'none';
    setTimeout(() => {
        tipText.innerHTML = parseServerText(tip);
        tipText.style.animation = 'tipFade 1s ease-in-out';
    }, 10);
}

function populateResources(resources) {
    const container = document.getElementById('resources-list');
    container.innerHTML = '';
    
    resources.forEach((resource, index) => {
        const item = document.createElement('div');
        item.className = 'resource-item';
        item.textContent = resource;
        item.style.opacity = index < 1 ? '1' : '0.3';
        container.appendChild(item);
    });

    document.getElementById('resources-container').classList.remove('hidden');
}

function updateResourcesList(count) {
    const items = document.querySelectorAll('.resource-item');
    items.forEach((item, index) => {
        if (index < count) {
            item.style.opacity = '1';
        } else {
            item.style.opacity = '0.3';
        }
    });
}

function skipLoading() {
    fetch(`https://${GetParentResourceName()}/skip`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
    });
}

function handleKeyPress(event) {
    if (event.key === 'Escape') {
        skipLoading();
    }
}

function parseServerText(text) {
    // Parse ~r~, ~g~, ~b~, ~y~, ~o~, ~p~, ~s~ color codes
    return text
        .replace(/~r~/g, '<span style="color: #ff0000;">')
        .replace(/~g~/g, '<span style="color: #00ff00;">')
        .replace(/~b~/g, '<span style="color: #0096ff;">')
        .replace(/~y~/g, '<span style="color: #ffff00;">')
        .replace(/~o~/g, '<span style="color: #ff6600;">')
        .replace(/~p~/g, '<span style="color: #ff00ff;">')
        .replace(/~s~/g, '</span>');
}

// Get parent resource name (for fetch calls)
function GetParentResourceName() {
    return 'qb-loading';
}
