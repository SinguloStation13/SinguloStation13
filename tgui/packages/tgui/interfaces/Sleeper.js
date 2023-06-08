import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section, AnimatedNumber } from '../components';
import { Window } from '../layouts';
import { toFixed } from 'common/math';

export const Sleeper = (props, context) => {
  const { act, data } = useBackend(context);

<<<<<<< HEAD
  const {
    open,
    occupant = {},
    occupied,
  } = data;
=======
  const { open, occupant = {}, occupied, chems = [] } = data;
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))

  const preSortChems = data.chems || [];
  const chems = preSortChems.sort((a, b) => {
    const descA = a.name.toLowerCase();
    const descB = b.name.toLowerCase();
    if (descA < descB) {
      return -1;
    }
    if (descA > descB) {
      return 1;
    }
    return 0;
  });

  const damageTypes = [
    {
      label: 'Brute',
      type: 'bruteLoss',
    },
    {
      label: 'Burn',
      type: 'fireLoss',
    },
    {
      label: 'Toxin',
      type: 'toxLoss',
    },
    {
      label: 'Oxygen',
      type: 'oxyLoss',
    },
  ];

<<<<<<< HEAD
=======
  const ELLIPSIS_STYLE = {
    // enforces overflow ellipsis
    'max-width': '1px',
    'white-space': 'nowrap',
    'text-overflow': 'ellipsis',
    'overflow': 'hidden',
  };

>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
  return (
    <Window width={310} height={520}>
      <Window.Content>
        <Section
          title={occupant.name ? occupant.name : 'No Occupant'}
          minHeight="250px"
          buttons={
            !!occupant.stat && (
              <Box inline bold color={occupant.statstate}>
                {occupant.stat}
              </Box>
            )
          }>
          {!!occupied && (
            <>
              <ProgressBar
                value={occupant.health}
                minValue={occupant.minHealth}
                maxValue={occupant.maxHealth}
                ranges={{
                  good: [50, Infinity],
                  average: [0, 50],
                  bad: [-Infinity, 0],
                }}
              />
              <Box mt={1} />
              <LabeledList>
                {damageTypes.map((type) => (
                  <LabeledList.Item key={type.type} label={type.label}>
                    <ProgressBar
                      value={occupant[type.type]}
                      minValue={0}
                      maxValue={occupant.maxHealth}
<<<<<<< HEAD
                      color="bad" />
=======
                      color={occupant[type.type] === 0 ? 'good' : 'bad'}
                    />
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
                  </LabeledList.Item>
                ))}
                <LabeledList.Item label="Cells" color={occupant.cloneLoss ? 'bad' : 'good'}>
                  {occupant.cloneLoss ? 'Damaged' : 'Healthy'}
                </LabeledList.Item>
                <LabeledList.Item label="Brain" color={occupant.brainLoss ? 'bad' : 'good'}>
                  {occupant.brainLoss ? 'Abnormal' : 'Healthy'}
                </LabeledList.Item>
                <LabeledList.Item label="Reagents">
                  <Box color="label">
                    {occupant.reagents.length === 0 && '—'}
                    {occupant.reagents.map((chemical) => (
                      <Box key={chemical.name}>
                        <AnimatedNumber value={chemical.volume} format={(value) => toFixed(value, 1)} />
                        {` units of ${chemical.name}`}
                      </Box>
                    ))}
                  </Box>
                </LabeledList.Item>
              </LabeledList>
            </>
          )}
        </Section>
        <Section
          title="Medicines"
          minHeight="205px"
<<<<<<< HEAD
          buttons={(
            <Button
              icon={open ? 'door-open' : 'door-closed'}
              content={open ? 'Open' : 'Closed'}
              onClick={() => act('door')} />
          )}>
          {chems.map(chem => (
            <Button
              key={chem.name}
              icon="flask"
              content={chem.name}
              disabled={!(occupied && chem.allowed)}
              width="140px"
              onClick={() => act('inject', {
                chem: chem.id,
              })}
            />
          ))}
=======
          buttons={
            <Button icon={open ? 'door-open' : 'door-closed'} content={open ? 'Open' : 'Closed'} onClick={() => act('door')} />
          }>
          <Table>
            <style>
              {`
              .Button--fluid.button-ellipsis {
                max-width: 100%;
              }
              .button-ellipsis .Button__content {
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
              }
            `}
            </style>
            {chems.map((chem) => (
              <Table.Row key={chem.id}>
                <Table.Cell style={ELLIPSIS_STYLE}>
                  <Button
                    key={chem.id}
                    icon="flask"
                    className="button-ellipsis"
                    fluid
                    content={chem.name + ' (' + chem.amount + 'u)'}
                    tooltip={chem.amount + 'u'}
                    disabled={!(occupied && chem.allowed)}
                    onClick={() =>
                      act('inject', {
                        chem: chem.id,
                      })
                    }
                  />
                </Table.Cell>
                <Table.Cell collapsing>
                  <Button
                    key={chem.id}
                    icon="eject"
                    content="Eject"
                    onClick={() =>
                      act('eject', {
                        chem: chem.id,
                      })
                    }
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
>>>>>>> 1cfc850830 (Standardizes JS formatting with PrettierX (#9198))
        </Section>
      </Window.Content>
    </Window>
  );
};
