@isTest
public class HelloWorldClassTest {
    
    @isTest
    static void testSayHelloWithName() {
        String result = HelloWorldClass.sayHello('Aniruddh');
        System.assertEquals('Hello, Aniruddh!', result);
    }
    
    @isTest
    static void testSayHelloWithBlank() {
        String result = HelloWorldClass.sayHello('');
        System.assertEquals('Hello, Guest!', result);
    }
}