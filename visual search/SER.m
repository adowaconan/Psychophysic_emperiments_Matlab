function [standardError] = SER(data)
standardError = std(data) ./ sqrt(length(data)-1);