Ubuntu UI Extras
================

A collection of QML widgets not available in the default Ubuntu UI Toolkit.

### Included Widgets ###

 * Sidebar

### How to Use ###

To use, you will need [Code Units](https://github.com/iBeliever/code-units), a small utility to download bits of code.

Once Code Units is installed, you can use the Ubuntu UI Extras by running

    code install ubuntu-ui-extras
    code use ubuntu-ui-extras

And make sure you add `ubuntu-ui-extras` to your git ignore.

To update the `ubuntu-ui-extras`, run:

    code update ubuntu-ui-extras

To use a component from QML, import it like this:

    import "ubuntu-ui-extras"
    
Or, if you're in a subdirectory like `ui` or `components`, you'll need

    import "../ubuntu-ui-extras"
    
Than use whatever components you want just as any component in the Ubuntu UI Toolkit!
