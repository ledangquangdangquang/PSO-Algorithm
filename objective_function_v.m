% function objective_value = objective_function_v(u, v0, IR_3, omega_1, omega_2, tau)
% 
%     % Tính toán giá trị tích phân và hàm mục tiêu
%     result = zeros(10, 1);
%     integral_value = zeros(10, 1);
% 
%     for i = 1:10
%         c = dot(omega_1, omega_2);
%         mul = u(:, 1) * exp(-1j * 2 * pi * v0) * c .* IR_3(:, i);
%         integral_value(i) = trapz(tau, mul);
%         % Sum the squared absolute values of integral value
%         a = real(integral_value(i));
%         b = imag(integral_value(i));
%         result(i) = a*a + b*b;
%     end
% 
%     % Tổng các kết quả cuối cùng
%     sum_columns = sum(result);
% 
%     % Trả về giá trị của hàm
%     objective_value = round(sum_columns, 8);
% end
function objective_value = objective_function_v(u, v0, IR_3, omega_1, omega_2, tau)
    % Tính hệ số kênh: cos góc giữa sóng tới và sóng phát
    c = dot(omega_1, omega_2);  % scalar

    % Điều chế Doppler
    exp_dopp = exp(-1j * 2 * pi * v0 * tau);  % [15000 x 1]
    u_dopp = u .* exp_dopp;                  % [15000 x 1]

    % Tính năng lượng khớp giữa tín hiệu và kênh nhận
    result = zeros(10, 1);
    for i = 1:10
        s = u_dopp * c;              % [15000 x 1]
        y = IR_3(:, i);              % [15000 x 1]
        val = trapz(tau, s .* conj(y));
        result(i) = abs(val)^2;
    end

    % Tổng toàn kênh
    objective_value = sum(result);  % Không round để tối ưu mượt hơn
end
