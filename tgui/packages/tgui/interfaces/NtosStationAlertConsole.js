import { NtosWindow } from '../layouts';
import { StationAlertConsoleContent } from './StationAlertConsole';

export const NtosStationAlertConsole = () => {
  return (
<<<<<<< HEAD
    <NtosWindow
      width={315}
      height={500}>
=======
    <NtosWindow width={335} height={587}>
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
      <NtosWindow.Content scrollable>
        <StationAlertConsoleContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
