import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const CryptoMiningRig = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    on,
    max_overclock,
    overclock_amount,
    max_coolant,
    coolant_amount,
  } = data;

  return (
    <Window width={335} height={135}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Power">
              <Button
                icon={on ? 'power-off' : 'times'}
                content={on ? 'On' : 'Off'}
                selected={on}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Coolant">
              {coolant_amount}U / {max_coolant}U
              <Button
                ml={1}
                icon='tint'
                content='Purge'
                onClick={() => act('purge')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Overclock">
              <Button
                mr={1}
                icon="minus"
                content="Min"
                disabled={overclock_amount === 0}
                onClick={() =>
                  act('overclock', {
                    overclock: 0,
                  })
                }
              />
              <NumberInput
                animated
                value={overclock_amount}
                width="63px"
                unit="W"
                minValue={0}
                maxValue={max_overclock}
                onChange={(_, value) =>
                  act('overclock', {
                    overclock: value,
                  })
                }
              />
              <Button
                ml={1}
                icon="plus"
                content="Max"
                disabled={overclock_amount === max_overclock}
                onClick={() =>
                  act('overclock', {
                    overclock: max_overclock,
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
