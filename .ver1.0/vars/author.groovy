def call(){
    echo "Hello World!"
    echo "Created by Dmitry, system:"
    sh """
        cat /etc/os-release
    """
}