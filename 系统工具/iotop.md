## iotop

`be` Best-effort. The kernel does its best to fairly schedule I/O for this
class. Most processes run under this I/O scheduling class.
`rt` Real-time. The kernel schedules any real-time I/O before any other
class of I/O, no matter what.
`idle` Idle. The kernel performs I/O for this class only when there is no
other I/O to be done. There is no priority level for the idle scheduling
class.
You can check and change the I/O priority for a process with the `ionice`
utility; see the ionice(1) manual page for details. You probably will never
need to worry about the I/O priority, though.