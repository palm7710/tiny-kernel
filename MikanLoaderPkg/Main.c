#include  <Uefi.h>
#include  <Library/UefiLib.h>

EFI_STATUS EFIAPI UefiMain(
    IN EFI_HANDLE ImageHandle,
    IN EFI_SYSTEM_TABLE *SystemTable
    )
{
    // UEFIコンソールをクリア
    SystemTable->ConOut->ClearScreen(SystemTable->ConOut);
    
    Print(L"Hello, Mikan World!\n");
    return EFI_SUCCESS;

}
