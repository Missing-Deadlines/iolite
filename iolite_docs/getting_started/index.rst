👀 Getting Started
===================

This section contains installation instructions and guides to get you started.

Installing IOLITE
-----------------

Download a release from the `landing page <https://iolite-engine.com>`_ or, if you have subscribed to IOLITE PRO, from the `subscriber area <https://iolite-engine.com/subscribers>`_ and unzip it. Finally, launch the IOLITE executable. That's it. 🙂 

If you encounter an issue when running IOLITE, please consult the section :ref:`faq`. If you are unable to solve the issue, please follow the steps depicted in :ref:`reporting_issues`.

Beta releases
-------------

Beta releases are released in between main releases for PRO subscribers. Please consider the following when working with a beta release of IOLITE:

.. important:: Beta releases are released more frequently and contain the latest features, but they can be a little less stable.

- Please switch to the ``develop`` branch in our public GitHub repository and search for a tag matching the version of IOLITE you are using
- Please ensure that you are using a matching version of the open-source plugins. Due to potential API changes, there are separate plugin releases available for the beta versions of IOLITE
  
Telemetry (Usage statistics)
----------------------------

IOLITE, by default, gathers some elementary **anonymous usage statistics** to aid the development.

.. note:: This system will be extended in the future also to report crashes.

The following data is collected for each of the logged events:

UUID
   A unique identifier based on a **hash** of the addresses of **all** the network adapters installed in your system, e.g., ``8A36-E187-2C1F-51FB``. This hash **can not be** reversed to get access to the MAC addresses of your adapters
Platform
   Either ``Windows`` or ``Linux``
Build
  Either ``Free`` or ``Pro``
API version
  The version of the API, e.g., ``0.4.0``
Event name
  The event's name, e.g., ``startup``, ``shutdown``, etc.
Event metadata
  Currently unused and reserved for future use
  
You can turn off the telemetry system at any time by adding the following member to your ``app_metadata.json`` file:

.. code-block:: json
   
  "disable_telemetry": true

Writing your first "Hello, World!" script in Lua
------------------------------------------------

This short tutorial serves as a step-by-step guide to writing your first Lua script in IOLITE.

.. important::
  This guide requires the latest version of the Lua plugin for IOLITE to be installed. Please check the section :ref:`working_with_plugins` for more details.

Open up your favorite code editor and create a new file. Copy and paste the following Lua script, which logs two strings to the console:

.. code-block:: lua

  Log.load()

  -- Logs each time the script gets (re-)loaded
  Log.log_info("Hello world! Script loaded!")

  function OnActivate(entity)
    -- Logs once the component becomes active
    Log.log_info("Hello world! Component active!")
  end

After that, continue with the following steps:

1. Store the script in ``default/media/scripts/`` and name it ``hello_world.lua``
2. Open up IOLITE, ensure that the editor is active, and head over to the *World Inspector*
3. Create a new entity with a script component attached to it
4. In the property inspector, set the ``Script`` property to ``hello_world`` (without the extension)
5. Switch to the game mode by clicking ``[Game Mode]`` in the menu bar
6. Press ``[F2]`` to open up the console and check if the strings have been logged successfully

Keep IOLITE open and modify the strings passed to the log functions. Every time you save the script, it triggers a hot reload. Notice how the global log call gets executed while the call in ``OnActivate`` is not. This call can be, e.g., triggered by switching back and forth between the game mode and the editor; the editor can be activated using ``[F3]``.
