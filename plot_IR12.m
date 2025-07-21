numPlotsPerFigure = 10;
subplotRows = 5;
subplotCols = 2;
s = adda(u, IR_12, B(1, :), A(1, 3), A(1, 7),A(1, 6));
% Gọi hàm cho từng ma trận
createMultiSubplotFigure(1, IR_12, 'IR_{12}', numPlotsPerFigure, subplotRows, subplotCols, tau);
createMultiSubplotFigure(2, IR_3, 'IR_3', numPlotsPerFigure, subplotRows, subplotCols, tau);
createMultiSubplotFigure(3, s, 's', numPlotsPerFigure, subplotRows, subplotCols, tau);

disp('Đã hoàn tất việc vẽ biểu đồ.');






function createMultiSubplotFigure(figureHandle, dataMatrix, baseTitle, numPlots, rows, cols, tau)
    figure(figureHandle); % Chọn hoặc tạo figure được chỉ định
    sgtitle(['Biểu đồ cho ', baseTitle]); % Tiêu đề chung

    for i = 1:numPlots
        subplot(rows, cols, i);
        plot( real(dataMatrix(:, i)));
    end

    for i = 1:numPlots
        subplot(rows, cols, i);
        plot( abs(dataMatrix(:, i)));
   end
end
function s = adda(u, IR_12, omega_1, theta_1, alpha, v)
    % Khởi tạo các biến và thông số
    lambda = 1; % Bước sóng
    load("pos.mat", "pos_centers")
    I = 10;
    r_m = pos_centers(:, 11:20)';
    for m = 1:I
        c_m(m) = sqrt(sin(theta_1)) * exp(1j * 2 * pi * lambda^(-1) * dot(conj(omega_1)', r_m(m, :)));
    end
    
    % Transpose để có hàm c(phi) là ma trận kích thước [I x length(phi)]
    c = c_m;
    s = alpha * exp(1j*2*pi*v) * u * c;
end