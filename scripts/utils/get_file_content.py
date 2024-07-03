def get_file_content(file_path: str):
    with open(file_path) as file:
        return file.read()
