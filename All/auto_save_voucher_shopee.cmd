// Tự động lưu vouchers Shopee
// Khai báo biến htm để lưu trữ nội dung HTML.
let htm = '';

// Hàm fetchData để gửi yêu cầu HTTP và nhận dữ liệu từ URL.
async function fetchData(url) {
    try {
        const response = await fetch(url);
        const data = await response.json();
        return data;
    } catch (error) {
        // Xử lý lỗi nếu có khi fetch dữ liệu và cập nhật nội dung HTML.
        htm += '<h3 style="color:blue">Error fetching data: ' + error + '</p>';
        return null;
    }
}

// Hàm addVoucher để thêm Voucher vào Shopee.
async function addVoucher(oPayload) {
    try {
        const response = await fetch("https://shopee.vn/api/v2/voucher_wallet/save_voucher", {
            "headers": {
                "accept": "application/json",
                "accept-language": "en-US,en;q=0.9",
                "cache-control": "no-cache",
                "content-type": "application/json",
                "pragma": "no-cache",
                "sec-ch-ua": "\"Google Chrome\";v=\"119\", \"Chromium\";v=\"119\", \"Not?A_Brand\";v=\"24\"",
                "sec-ch-ua-mobile": "?0",
                "sec-ch-ua-platform": "\"Windows\"",
                "sec-fetch-dest": "empty",
                "sec-fetch-mode": "cors",
                "sec-fetch-site": "same-origin",
                "x-api-source": "pc",
                "x-requested-with": "XMLHttpRequest",
                "x-shopee-language": "vi",
                "x-sz-sdk-version": "3.1.0-2&1.5.1"
            },
            "referrer": "https://shopee.vn/user/voucher-wallet",
            "referrerPolicy": "strict-origin-when-cross-origin",
            "body": JSON.stringify(oPayload),
            "method": "POST",
            "mode": "cors",
            "credentials": "include"
        });
        const responseData = await response.json();
        if (responseData && responseData.error == 4) {
            console.error("Thêm Voucher: " + oPayload.voucher_code + " - Lỗi: " + responseData.error_msg);
        } else {
            console.log("Thêm Voucher thành công:", oPayload.voucher_code);
        }
    } catch (error) {
        console.error("Thêm Voucher lỗi: ", error);
    }
}

// Hàm saveVoucherCode để lưu mã voucher bằng cách gửi yêu cầu HTTP POST đến Shopee.
async function saveVoucherCode(voucher) {
    const oPayload = {
        "voucher_code": voucher,
        "need_user_voucher_status": true
    };
    await addVoucher(oPayload);
}

// Hàm saveVouchers để lấy danh sách mã voucher từ một URL và thêm chúng vào Shopee.
async function saveVouchers() {
    const url = "https://addlivetag.com/api/voucher_json.php";
    const data = await fetchData(url);
    if (!data || !data.vouchers) {
        console.error("Không tìm thấy dữ liệu voucher.");
        return;
    }
    const vouchers = Object.values(data.vouchers);
    alert("Tổng số voucher tìm được: " + vouchers.length);
    const speed = prompt("Nhập tốc độ lưu mã (0.25 ~ 0.5 giây):");
    if (isNaN(speed)) {
        console.error("Tốc độ không hợp lệ.");
        return;
    }
    for (const voucher of vouchers) {
        await saveVoucherCode(voucher);
        await new Promise(resolve => setTimeout(resolve, speed * 1000));
    }
    console.log("Đã thêm tất cả Vouchers thành công.");
}

// Gọi hàm saveVouchers để bắt đầu quá trình lấy và thêm các mã voucher vào Shopee.
saveVouchers();