public class HelloWorldClass {
    
    // Method to return a greeting
    public static String sayHello(String name) {
        if(String.isBlank(name)) {
            return 'Hello, Guest!';
        }
        return 'Hello, ' + name + '!';
    }
}