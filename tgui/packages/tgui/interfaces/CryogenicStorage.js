import { toTitleCase } from 'common/string';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section, Table, Tooltip } from '../components';
import { Window } from '../layouts';

const OccupantEntry = (props, context) => {
  const { occupant, ejectOccupant } = props;
  const { Oref, name, rank, species, highlight } = occupant;
  return (
    <Table.Row>
      <Button
        icon="eject"
        my={1}
        color={highlight ? 'average' : 'good'}
        content={name + " - " + rank + " (" + species + ")"}
        tooltip={highlight ? "Occupant has high value item(s) in belongings." : ""}
        onClick={() => ejectOccupant(Oref)} />
    </Table.Row>
  );
};

export const CryogenicStorage = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    occupants = [],
  } = data;
  return (
    <Window
      title="Cryogenic Oversight Console"
      resizable
      width={400}
      height={300}>
      <Window.Content
        scrollable>
        <Section>
          <NoticeBox
            textAlign="center">
            You will be held in full liability for any damages to
            the occupant that you eject of your own accord.
          </NoticeBox>
          <Button
            icon="eject"
            color="bad"
            content="Eject All"
            onClick={() => act('eject_all')} />
        </Section>
        <Section
          title="Occupants">
          <Table
            collapsing>
            {occupants.map(O => (
              <OccupantEntry
                key={O.Oref}
                occupant={O}
                ejectOccupant={Oref => act('eject_occupant', {
                  ref: Oref,
                })} />
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
