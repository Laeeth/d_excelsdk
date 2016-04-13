/**
	MemoryManager.D

	Ported from MemoryManager.cpp by Laeeth Isharc


//
// Purpose:     The memory manager class is an update to the memory manager
//              in the previous release of the framework.  This class provides
//              each thread with an array of bytes to use as temporary memory.
//              The size of the array, and the methods for dealing with the
//              memory explicitly, is in the class MemoryPool.  
//
//              MemoryManager handles assigning of threads to pools, and the
//              creation of new pools when a thread asks for memory the first
//              time.  Using a singleton class, the manager provides an interface
//              to C code into the manager.  The number of unique pools starts
//              as MEMORYPOOLS, defined in MemoryManager.h.  When a new thread
//              needs a pool, and the current set of pools are all assigned,
//              the number of pools increases by a factor of two.
// 
// Platform:    Microsoft Windows
//
///***************************************************************************
*/

//
// Total number of memory allocation pools to manage
//
import core.sys.windows.windows;
//import std.c.windows.windows;
import xlcall;
import xlcallcpp;
import memorypool;

enum MEMORYPOOLS=4;

struct MemoryManager
{
	private int m_impCur=0;		// Current number of pools
	private int m_impMax=MEMORYPOOLS;		// Max number of mem pools
	static private MemoryPool[] m_rgmp;	// Storage for the memory pools


	//
	// Returns the singleton class, or creates one if it doesn't exit
	//
	static MemoryManager* GetManager()
	{
		if (!vpmm)
		{
			vpmm = new MemoryManager();
			this.m_rgmp.length=MEMORYPOOLS;
		}
		return vpmm;
	}

	
	//
	// Destructor.  Because of the way memory pools get copied,
	// this function needs to call an additional function to clear
	// up the MemoryPool memory - the deconstructor on MemoryPool
	// does not actually delete its memory
	//
	~this()
	{
/**
		foreach(pmp;m_rgmp)
		{
			if (pmp.m_rgchMemBlock !is null)
				pmp.ClearPool();
		}
		// delete [] m_rgmp;
*/	}

	//
	// Method that will query the correct memory pool of the calling
	// thread for a set number of bytes.  Returns 0 if there was a
	// failure in getting the memory.
	//
	ubyte* CPP_GetTempMemory(size_t cByte)
	//LPSTR CPP_GetTempMemory(size_t cByte)
	{
		DWORD dwThreadID;
		MemoryPool* pmp;

		dwThreadID = GetCurrentThreadId(); //the id of the calling thread
		pmp = GetMemoryPool(dwThreadID);

		if (!pmp) //no more room for pools
		{
			return null;
		}

		return pmp.GetTempMemory(cByte);
	}

	//
	// Method that tells the pool owned by the calling thread that
	// it is free to reuse all of its memory
	//
	void CPP_FreeAllTempMemory()
	{
		DWORD dwThreadID;
		MemoryPool* pmp;

		dwThreadID = GetCurrentThreadId(); //the id of the calling thread
		pmp = GetMemoryPool(dwThreadID);

		if (!pmp) //no more room for pools
		{
			return;
		}

		pmp.FreeAllTempMemory();
	}

	//
	// Method iterates through the memory pools in an attempt to find
	// the pool that matches the given thread ID. If a pool is not found,
	// it creates a new one
	//
	private MemoryPool* GetMemoryPool(DWORD dwThreadID)
	{
		int imp; //loop var
		
		foreach(i,pmp;m_rgmp)
		{
			if (pmp.m_dwOwner == dwThreadID)
			{
				return &m_rgmp[i];
			}
		}

		return CreateNewPool(dwThreadID); //didn't find the owner, make a new one
	}

	//
	// Will assign an unused pool to a thread; should all pools be assigned,
	// it will grow the number of pools available.
	//
	private MemoryPool* CreateNewPool(DWORD dwThreadID)
	{
		if (m_impCur >= m_impMax)
		{
			GrowPools();
		}
		m_rgmp[m_impCur++].m_dwOwner = dwThreadID;

		return &m_rgmp[m_impCur-1];
	}

	//
	// Increases the number of available pools by a factor of two. All of
	// the old pools have their memory pointed to by the new pools. The
	// memory for the new pools that get replaced is first freed. The reason
	// ~MemoryPool() can't free its array is in this method - they would be
	// deleted when the old array of pools is freed at the end of the method,
	// despite the fact they are now being pointed to by the new pools.
	//
	void GrowPools()
	{
		MemoryPool* rgmpTemp;
		MemoryPool* pmpDst;
		MemoryPool* pmpSrc;

		int i, impMaxNew;

		impMaxNew = 2*m_impMax;
		m_rgmp.length=2*m_impMax;
		/**
		pmpDst = rgmpTemp = new MemoryPool(2*m_impMax);
		pmpSrc = m_rgmp;

		for (i = 0; i < m_impCur; i++)
		{
			//delete [] pmpDst.m_rgchMemBlock;
			pmpDst.m_rgchMemBlock = pmpSrc.m_rgchMemBlock;
			pmpDst.m_dwOwner = pmpSrc.m_dwOwner;

			pmpDst++;
			pmpSrc++;
		}
		m_rgmp = rgmpTemp;
		*/
		m_impMax = impMaxNew;
	}
}

//
// Singleton instance of the class
//
__gshared MemoryManager* vpmm;

//
// Interface for C callers to ask for memory
//
// See MemoryPool.h for more details
//
//LPSTR MGetTempMemory(size_t cByte)
ubyte* MGetTempMemory(size_t cByte)
{
	return MemoryManager.GetManager().CPP_GetTempMemory(cByte);
}

//
// Interface for C callers to allow their memory to be reused
//
// See MemoryPool.h for more details
//
void MFreeAllTempMemory()
{
	MemoryManager.GetManager().CPP_FreeAllTempMemory();
}
