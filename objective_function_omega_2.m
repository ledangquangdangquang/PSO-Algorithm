function [objective_value, omega_2] = objective_function_omega_2(u, variables, IR_3, tau)
    % Biến góc
    phi_2 = variables(1);
    theta_2 = variables(2);

    % Máy phát: vector hướng 2D
    omega_2 = [cos(phi_2), sin(phi_2)];  % Vì phát 2D

    % Tính hệ số phát (scalar)
    cH_phi_2 = calculate_cH_omega_2(omega_2, theta_2);  % scalar

    % Tích phân trên mỗi anten thu
    result = zeros(size(IR_3, 2), 1);
    for i = 1:size(IR_3, 2)
        s = u * cH_phi_2;           % [15000 x 1]
        y = IR_3(:, i);             % [15000 x 1]
        val = trapz(tau, s .* conj(y));
        result(i) = abs(val)^2;
    end

    % Tổng toàn kênh
    objective_value = sum(result);  % Không cần round
end

% function [objective_value, omega_2] = objective_function_omega_2(u, variables, IR_3, tau)
% 
%     phi_2 = variables(1);
%     theta_2 = variables(2);
% 
%     % Máy phát: vector hướng omega_2
%     omega_2 = [cos(phi_2) * sin(theta_2), sin(phi_2) * sin(theta_2), cos(theta_2)];
% 
%     % Tính hệ số phát (scalar)
%     cH_phi_2 = calculate_cH_omega_2(omega_2, theta_2);  % scalar
% 
%     result = zeros(size(IR_3, 2), 1);
%     for i = 1:size(IR_3, 2)
%         s = u(:, 1) * cH_phi_2;         % [15000 x 1] * scalar
%         mul = s .* IR_3(:, i);          % nhân từng phần tử
%         a = real(trapz(tau, mul));
%         b = imag(trapz(tau, mul));
%         result(i) = a^2 + b^2;
%     end
% 
%     objective_value = round(sum(result), 8);
% end
