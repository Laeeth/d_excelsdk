/**
MemoryPool.d - port of MemoryPool.cpp and MemoryPool.h by Laeeth Isharc
//
// Purpose:		Class definition for the memory pool class used by the
//				memory manager.  Each pool is a block of memory set
//				aside for a specific thread for use in creating temporary
//				XLOPER/XLOPER12's in the framework
//
// Purpose:     A memory pool is an array of characters that is pre-allocated,
//              and used as temporary memory by the caller. The allocation
//              algorithm is very simple. When a thread asks for some memory,
//              the index into the array moves forward by that many bytes, and
//              a pointer is returned to the previous index before the pointer
//              was advanced. When a call comes to free all of the memory, the
//              pointer is set back to the beginning of the array.
//
//              Each pool has MEMORYSIZE bytes of storage space available to it
// 
// Platform:    Microsoft Windows
//
///***************************************************************************
*/
import core.sys.windows.windows;
//import std.c.windows.windows;

//
// Total amount of memory to allocate for all temporary XLOPERs
//

enum MEMORYSIZE=10240;

struct MemoryPool
{
	DWORD m_dwOwner=cast(DWORD)-1;			// ID of ownning thread
	ubyte[MEMORYSIZE] m_rgchMemBlock;		// Memory for temporary XLOPERs
	size_t m_ichOffsetMemBlock=0;	// Offset of next memory block to allocate

	// An empty destructor - see reasoning below
	//
	~this()
	{
	}

	//
	// Unable to delete the memory block when we delete the pool,
	// as it may be still be in use due to a GrowPools() call; this
	// method will actually delete the pool's memory
	//

	void ClearPool()
	{
		//delete [] m_rgchMemBlock;
	}

	//
	// Advances the index forward by the given number of bytes.
	// Should there not be enough memory, or the number of bytes
	// is not allowed, this method will return 0. Can be called
	// and used exactly as malloc().
	//
	ubyte* GetTempMemory(size_t cBytes)
	//LPSTR GetTempMemory(size_t cBytes)
	{
		ubyte* lpMemory;

		if (m_ichOffsetMemBlock + cBytes > MEMORYSIZE || cBytes <= 0)
		{
			return null;
		}
		else
		{
			lpMemory = cast(ubyte*) m_rgchMemBlock + m_ichOffsetMemBlock;
			m_ichOffsetMemBlock += cBytes;

			return lpMemory;
		}
	}

	//
	// Frees all the temporary memory by setting the index for
	// available memory back to the beginning
	//
	void FreeAllTempMemory()
	{
		m_ichOffsetMemBlock = 0;
	}
}