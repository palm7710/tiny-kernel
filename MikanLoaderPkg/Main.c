#include  <Uefi.h>
#include  <Library/UefiLib.h>

EFI_STATUS EFIAPI UefiMain(
    IN EFI_HANDLE ImageHandle,
    IN EFI_SYSTEM_TABLE *SystemTable
    )
{
    // UEFIコンソールをクリア
    SystemTable->ConOut->Reset(SystemTable->ConOut, TRUE);
    SystemTable->ConOut->ClearScreen(SystemTable->ConOut);
    SystemTable->ConOut->SetCursorPosition(SystemTable->ConOut, 0, 0);
    Print(L"Hello, Mikan World!\n");
    while (1) { __asm__ __volatile__("hlt"); } // CPUを無駄に回さず停止
    // return EFI_SUCCESS;
}
