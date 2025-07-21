function cH_phi = calculate_cH_omega_2(omega_2, theta_2)
    lambda = 1;
    load("VA.mat", "used_VAs");
    r_tx = -used_VAs{1,1}(:,1);  % [2 x 1]

    omega_2 = reshape(omega_2, 1, []);  % [1 x 2]
    r_tx = reshape(r_tx, 1, []);        % [1 x 2]
    phase = sum(conj(omega_2) .* r_tx);
    cH_phi = sqrt(sin(theta_2)) * exp(1j * 2 * pi / lambda * phase);  % scalar
end
