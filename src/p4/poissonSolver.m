function [ out ] = poissonSolver( target, gradientField, mask )
%POISSONSOLVER Summary of this function goes here
%   @param target image (grayscale) represented as a (m x n) matrix.
%   @param gradientField gradient field from source image.
%   @param mask (m x n) a binary valued matrix.
%          the coordinates of entries that are equal zero
%          represent the position of the source imga in the target image.
%   @param out an image (grayscale) represented as a (m x n) matrix.
    
    % boundary condition and initial guess.
    out = target;


    % retrieve relevant pixel indices in image. 
    [I,J] = find(mask(:,:) == 0);
    
    % split directional components of gradient field
    vx = gradientField(:,:,2);
    vy = gradientField(:,:,1);
    
    % error tolerance
    EPS = 1E-8;
    
    % ensure termination of solver
    MAX_ITER = 10000;
    
    % do while loop with invariante: make loop deterministic
    iter = 0;
    while iter < MAX_ITER
        
        % update previous approx. Image
        prev_out = out;
        
        % compute new x values
        for k=1:length(I)
            i = I(k);
            j = J(k);
            
            imgNeighbors = prev_out(i-1,j) + prev_out(i+1,j) ...
                         + prev_out(i,j-1) + prev_out(i,j+1);
            gradNeighbors = vy(i-1,j)-vy(i,j)+vx(i,j-1)-vx(i,j);
            out(i,j) = (gradNeighbors+imgNeighbors)/4;
        end
        
        % end loop if error is below threshold EPS.
        if(abs(max(out(:)-prev_out(:))) < EPS)
            break;
        end
        
        % increment loop invariant
        iter = iter + 1;
    end
    
    disp(['took me ', num2str(iter), ' iterations'])
end

