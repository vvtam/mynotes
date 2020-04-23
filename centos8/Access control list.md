## Access control list

Traditionally, each file and directory can only have one user owner and one group owner at a time. If you want to apply a more specific set of permissions to a file or directory (allow certain users outside the group to gain access to a specific file within a directory but not to other files) without changing the ownership and permissions of a file or directory, you can use the access control lists (ACL).

The following section describes how to:

- Display the current ACL.
- Set the ACL.

### 5.7.1. Displaying the current ACL

The following section describes how to display the current ACL.

**Procedure**

- To display the current ACL for a particular file or directory, use:

  ```
  $ getfacl file-name
  ```

  Replace *file-name* with the name of the file or directory.

### 5.7.2. Setting the ACL

The following section describes how to set the ACL.

**Prerequisites**

- `Root` access

**Procedure**

- To set the ACL for a file or directory, use:

```
# setfacl -m u:username:symbolic_value file-name
```

Replace *username* with the name of the user, *symbolic_value* with a symbolic value, and *file-name* with the name of the file or directory. For more information see the `setfacl` man page.

**Example**

The following example describes how to modify permissions for the `group-project` file owned by the `root` user that belongs to the `root` group so that this file is:

- Not executable by anyone.
- The user `andrew` has the `rw-` permission.
- The user `susan` has the `---` permission.
- Other users have the `r--` permission.

**Procedure**



```
# setfacl -m u:andrew:rw- group-project
# setfacl -m u:susan:--- group-project
```



**Verification steps**

- To verify that the user `andrew` has the `rw-` permission, the user `susan` has the `---` permission, and other users have the `r--` permission, use:

  ```
  $ getfacl group-project
  ```

  The output returns:

  ```
  # file: group-project
  # owner: root
  # group: root
  user:andrew:rw-
  user:susan:---
  group::r--
  mask::rw-
  other::r--
  ```

[https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/file-permissions-rhel8_configuring-basic-system-settings](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/file-permissions-rhel8_configuring-basic-system-settings)