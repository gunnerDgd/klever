#include <linux/kernel.h> //Needed by all modules
#include <linux/module.h> //Needed for KERN_ALERT
#include <linux/init.h> //Needed for the macros

int __init hello_module_init(void)
{
    printk("Hello Module!\n");
    return 0;
}

void __exit hello_module_cleanup(void)
{
    printk("Bye Module!\n");
}

module_init(hello_module_init);
module_exit(hello_module_cleanup);
MODULE_LICENSE("GPL");