function path = anglePath2vectorPath(Path)

    path = zeros(6, size(Path,2));
    path(1:3,:) = Path(1:3,:);
    path(6,:) = cos(Path(5,:));
    path(4,:) = sin(Path(5,:)) .* cos(Path(4,:));
    path(5,:) = sin(Path(5,:)) .* sin(Path(4,:));

end