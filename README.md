# distcc-bare-metal-builder

A container definition for cross building w/ GCC using distcc in a Docker container to guarantee the same build environment across different machines. This setup allows for distributed compilation to speed up build times by leveraging multiple machines while keeping the same environment. It is particularly useful for large C/C++ projects where compilation can be parallelized across multiple machines.

## See

* <https://github.com/distcc/distcc>
* <https://linux.die.net/man/1/distcc>
* <https://ortogonal.github.io/cpp/distcc-cmake-qmake/>
* <https://tomlankhorst.nl/distcc-docker-service/>
* <https://developers.redhat.com/blog/2019/05/15/2-tips-to-make-your-c-projects-compile-3-times-faster#>

## Build

I use finch on an Apple Silicon Mac, so the commands will be slightly different than docker.w

```bash
finch build . -t distcc-bare-metal-builder
```

This should be build a version compatible with your Architecture!

```bash
$ finch images
REPOSITORY                   TAG       IMAGE ID        CREATED           PLATFORM          SIZE        BLOB SIZE
<none>                       <none>    c01137145099    7 minutes ago     linux/arm64       2.7 GiB     785.7 MiB
distcc-bare-metal-builder    latest    c01137145099    10 seconds ago    linux/arm64       2.7 GiB     785.7 MiB
```

## Running

```bash
finch run --detach -p 3633:3633 -p 3632:3632 distcc-bare-metal-builder:latest
```

## Is it running?

<http://127.0.0.1:3633/> or <http://0.0.0.0:3633/> should have a page that looks like this:

```
argv /distccd
<distccstats>
dcc_tcp_accept 0
dcc_rej_bad_req 0
dcc_rej_overload 0
dcc_compile_ok 0
dcc_compile_error 0
dcc_compile_timeout 0
dcc_cli_disconnect 0
dcc_other 0
dcc_longest_job none
dcc_longest_job_compiler none
dcc_longest_job_time_msecs -1
dcc_max_kids 5
dcc_avg_kids1 0
dcc_avg_kids2 0
dcc_avg_kids3 0
dcc_current_load 1
dcc_load1 0.05
dcc_load2 0.05
dcc_load3 0.01
dcc_num_compiles1 0
dcc_num_compiles2 0
dcc_num_compiles3 0
dcc_num_procstate_D 0
dcc_max_RSS 3072
dcc_max_RSS_name (distccd)
dcc_io_rate 0
dcc_free_space 30333 MB
</distccstats>
```

## Stopping

```bash
$ finch ps
...
# use ID from ps list
$ finch stop $ID
```
