function initializeCharts(thuChiData, danhMucLabels, danhMucData) {
    const rootStyles = getComputedStyle(document.documentElement);
    const successColor = rootStyles.getPropertyValue('--success').trim();
    const dangerColor = rootStyles.getPropertyValue('--danger').trim();

    // Biểu đồ 1: Thu nhập và chi tiêu
    const thuChiCtx = document.getElementById('thuChiChart').getContext('2d');
    new Chart(thuChiCtx, {
        type: 'bar',
        data: {
            labels: ['Thu nhập', 'Chi tiêu'],
            datasets: [{
                label: 'Số tiền - VNĐ',
                data: [thuChiData.ThuNhap, thuChiData.ChiTieu],
                backgroundColor: [successColor, dangerColor],
                borderColor: [successColor, dangerColor],
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Số tiền - VNĐ'
                    }
                }
            },
            plugins: {
                legend: { display: false }
            }
        }
    });

    // Biểu đồ 2: Phân bổ chi tiêu theo danh mục
    const danhMucColors = ['#5782ff', '#59ffc8', '#f0a3a3', '#f0ce86', '#cda0db'];

    if (danhMucData.length > 0) {
        const danhMucCtx = document.getElementById('danhMucChart').getContext('2d');
        new Chart(danhMucCtx, {
            type: 'pie',
            data: {
                labels: danhMucLabels,
                datasets: [{
                    label: 'Chi tiêu - VNĐ',
                    data: danhMucData,
                    backgroundColor: danhMucColors,
                    borderWidth: 1
                }]
            },
            options: {
                plugins: {
                    legend: { position: 'top' }
                }
            }
        });
    }
}

function startTradingFloorAnimation() {
    const container = document.querySelector('.trading-floor-container');
    const containerWidth = container.offsetWidth;
    const containerHeight = container.offsetHeight;

    // Tạo canvas cho biểu đồ đường
    const canvas = document.createElement('canvas');
    canvas.classList.add('line-chart');
    canvas.width = containerWidth;
    canvas.height = containerHeight;
    container.appendChild(canvas);
    const ctx = canvas.getContext('2d');

    // Vẽ trục X/Y
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.3)';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(30, 20); // Trục Y
    ctx.lineTo(30, containerHeight - 20);
    ctx.moveTo(30, containerHeight - 20); // Trục X
    ctx.lineTo(containerWidth - 20, containerHeight - 20);
    ctx.stroke();

    // Vạch chia trục X
    for (let i = 0; i <= 10; i++) {
        const x = 30 + (i * (containerWidth - 50) / 10);
        ctx.beginPath();
        ctx.moveTo(x, containerHeight - 25);
        ctx.lineTo(x, containerHeight - 15);
        ctx.stroke();
        ctx.fillStyle = 'rgba(255, 255, 255, 0.5)';
        ctx.font = '10px Arial';
        ctx.fillText(i * 10, x - 5, containerHeight - 5);
    }

    // Vạch chia trục Y
    for (let i = 0; i <= 5; i++) {
        const y = containerHeight - 20 - (i * (containerHeight - 40) / 5);
        ctx.beginPath();
        ctx.moveTo(25, y);
        ctx.lineTo(35, y);
        ctx.stroke();
        ctx.fillText(i * 20, 5, y + 3);
    }

    // Vẽ biểu đồ đường chính
    ctx.strokeStyle = '#FFFFFF';
    ctx.lineWidth = 2;
    ctx.beginPath();
    const points = 50;
    const stepX = containerWidth / (points - 1);
    let lastX = 30;
    let lastY = containerHeight / 2;
    ctx.moveTo(lastX, lastY);
    for (let i = 1; i < points; i++) {
        const x = lastX + stepX;
        const y = lastY + (Math.random() * 60 - 30);
        ctx.lineTo(x, Math.max(20, Math.min(containerHeight - 20, y)));
        lastX = x;
        lastY = y;
    }
    ctx.stroke();

    // Vẽ đường phụ mờ
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.2)';
    ctx.lineWidth = 1;
    ctx.beginPath();
    lastX = 30;
    lastY = containerHeight / 2 + 20;
    ctx.moveTo(lastX, lastY);
    for (let i = 1; i < points; i++) {
        const x = lastX + stepX;
        const y = lastY + (Math.random() * 40 - 20);
        ctx.lineTo(x, Math.max(20, Math.min(containerHeight - 20, y)));
        lastX = x;
        lastY = y;
    }
    ctx.stroke();

    // Tạo ví bay
    const wallet = document.createElement('div');
    wallet.classList.add('wallet-fly');
    container.appendChild(wallet);
    let walletX = 0;
    const walletWidth = 60;
    let time = 0;

    // Tạo danh sách icon tiền đô
    let dollars = [];

    // Tạo icon tiền đô ngẫu nhiên với thời gian biến mất
    function createDollar() {
        const dollar = document.createElement('div');
        dollar.classList.add('dollar-coin');
        dollar.innerHTML = '<i class="fas fa-dollar-sign"></i>';
        dollar.style.left = `${Math.random() * (containerWidth - 30)}px`;
        dollar.style.bottom = `${Math.random() * (containerHeight - 30)}px`;
        container.appendChild(dollar);
        dollars.push(dollar);

        // Biến mất sau 5 giây nếu không bị ăn
        setTimeout(() => {
            if (dollar.parentElement && !dollar.classList.contains('eaten')) {
                dollar.classList.add('timeout');
                setTimeout(() => {
                    dollar.remove();
                    dollars = dollars.filter(d => d !== dollar);
                }, 1000); // Đồng bộ với thời gian fadeOut
            }
        }, 5000); // 5 giây
    }

    // Tạo 8 icon tiền ban đầu
    for (let i = 0; i < 8; i++) {
        createDollar();
    }

    // Thêm icon mới mỗi 1 giây
    setInterval(createDollar, 1000);

    // Di chuyển ví xung quanh biểu đồ
    function moveWallet() {
        walletX += 3;
        if (walletX > containerWidth) walletX = -walletWidth;

        time += 0.05;
        const chartY = containerHeight / 2 + Math.sin(time) * 100;
        wallet.style.left = `${walletX}px`;
        wallet.style.bottom = `${chartY - 30}px`;

        // Kiểm tra va chạm với tiền đô
        dollars = dollars.filter(dollar => {
            const dollarRect = dollar.getBoundingClientRect();
            const walletRect = wallet.getBoundingClientRect();

            if (
                walletRect.right > dollarRect.left &&
                walletRect.left < dollarRect.right &&
                walletRect.bottom > dollarRect.top &&
                walletRect.top < dollarRect.bottom &&
                !dollar.classList.contains('eaten') &&
                !dollar.classList.contains('timeout')
            ) {
                dollar.classList.add('eaten');
                setTimeout(() => {
                    dollar.remove();
                }, 500);
                return false;
            }
            return true;
        });
    }

    // Di chuyển ví liên tục
    setInterval(moveWallet, 20);
}

