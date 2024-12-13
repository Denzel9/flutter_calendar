String toUpperCase(String string) => string.isNotEmpty
    ? string.substring(0, 1).toUpperCase() + string.substring(1)
    : '...';
