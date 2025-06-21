function linearIndices = get_linear_indices(Matrix, Indices)

[R, C] = size(Matrix);
linearIndices = sub2ind([R, C], Indices, 1:C);

end
