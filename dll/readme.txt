Please refer to https://community.bistudio.com/wiki/Arma_3:_Custom_Memory_Allocator for the most recent information about the memory allocators and dll folder in Arma 3.
It is possible to provide custom memory allocators for the game. The memory allocator is a very important component, which significantly affects both performance an stability of the game.
The purpose of this customization is to allow the allocator to be developed independently of the application, allowing both Bohemia Interactive and the community to fix bugs and improve performance without having to modify the core game files.

Default
=======
The default allocator used at the moment by the engine is based on Intel TBB 4 (see details about tbb4malloc_bi below)

Specifying a custom allocator
=============================
The allocator is a dll placed in a directory named "dll", located next to the game executable. The allocator search order is:
* tbb4malloc_bi - based on Intel TBB 4 (tbb2017_20161004oss), distributed under Apache 2.0 + RE (source code at: https://github.com/BohemiaInteractive/TBB4)
* jemalloc_bi - based on JEMalloc 4.3.1, distributed under BSD-derived license (source code at: https://github.com/BohemiaInteractive/JEMalloc)
* customMalloc_bi - not provided, feel free to plug-in your own
If no allocator dll is found, functions _aligned_malloc / _aligned_free (using Windows Heap functions) are used as a fallback. Important note: the Windows 7 allocator seems to be quite good, and it may therefore make sense for some users to delete all custom allocators on Windows 7 or newer).
You can select an allocator by deleting other allocators from the dll folder or via command line parameters.

Command line parameter
=====================
You can specify a particular allocator from a command line, like:
* -malloc=tbb4malloc_bi
* -malloc=jemalloc_bi
* -malloc=mybestmalloc_bi
(dll directory and extension are appended automatically, the allocator must not be located in other directory and its name must not contain any dots before the .dll extension)

Dedicated Server
================
You can specify an allocator for Windows Dedicated Server the same way as for the client binary, but the expected performance gain is minimal, because of low concurrency of the Dedicated Server code compared to a client.
Linux server uses the allocator provided by the operating system. There are NO plans to allow its customization.

DLL interface
=============
The dll interface is as follows:

extern "C" {
 __declspec(dllexport) size_t __stdcall MemTotalCommitted(); // _MemTotalCommitted@0 on x86
 __declspec(dllexport) size_t __stdcall MemTotalReserved(); // _MemTotalReserved@0 on x86
 __declspec(dllexport) size_t __stdcall MemFlushCache(size_t size); // _MemFlushCache@4 on x86
 __declspec(dllexport) void __stdcall MemFlushCacheAll(); // _MemFlushCacheAll@0 on x86
 __declspec(dllexport) size_t __stdcall MemSize(void *mem); // _MemSize@4 on x86
 __declspec(dllexport) void *__stdcall MemAlloc(size_t size); // _MemAlloc@4 on x86
 __declspec(dllexport) void __stdcall MemFree(void *mem); // _MemFree@4 on x86
 __declspec(dllexport) size_t __stdcall MemSizeA(void *mem, size_t aligment); // _MemSizeA@8 on x86
 __declspec(dllexport) void *__stdcall MemAllocA(size_t size, size_t aligment); // _MemAllocA@8 on x86
 __declspec(dllexport) void __stdcall MemFree(void *mem); // _MemFree@4 on x86
};

Note: besides the interface above, if the allocator is performing any per-thread caching, it will typically want to perform a cleanup of per-thread data on DLL_THREAD_DETACH event sent to DllMain function.
MemTotalCommitted():
Total memory committed by the allocator (should correspond to VirtualAlloc with MEM_COMMIT)
MemTotalReserved():
Total memory reserved by the allocator (should correspond to VirtualAlloc with MEM_RESERVE)
MemFlushCache(size_t size):
Try to flush at least "size" bytes of memory from caches and working areas, return how much memory was flushed. Called by the game when memory needs to be trimmed to reduce virtual memory use.
MemFlushCacheAll():
Flush all memory held in caches and working areas. Called by the game when memory needs to be trimmed to reduce virtual memory use.
MemSize(void *mem):
Return allocated size of given memory block.
MemAlloc(size_t size):
Allocate at least "size" bytes of memory, return the allocated memory. If the size is 16 B or more, the memory must be 16 B -aligned, so that it is usable to hold SSE data.
MemFree(void *mem):
Free given memory block.
MemSizeA(void *mem, size_t aligment):
Return allocated size of given memory block allocated via MemAllocA. Aligment must be the same as when MemAllocA was called.
MemAllocA(size_t size, size_t aligment):
Allocate at least "size" bytes of memory, return the allocated memory. Memory will be aligned to "aligment" bytes.
MemFreeA(void *mem):
Free given memory block allocated via MemAllocA.